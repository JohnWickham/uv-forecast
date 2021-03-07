//
//  DarkSkyAPI.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI
import Combine

enum APIError: LocalizedError {
    case request(code: Int, error: Error?)
	case noData
	case badRequest
    case unknown
	
	var errorDescription: String? {
		return "There was a problem loading UV index information."
	}
}

class APIClient: NSObject {
	
	static let APIKey: String = "accbf73888a364be5659f3fb1f453e8d"
	static let baseURL: URL = URL(string: "https://api.darksky.net/forecast/\(APIClient.APIKey)/")!
	
	typealias ForecastFetchResult = (currentUVIndex: UVIndex, dayHighForecast: UVForecast, forecastTimeline: ForecastTimeline)
	typealias ForecastFetchResultHandler = ((_ result: Result<ForecastFetchResult, APIError>) -> Void)
	
	func makeURLRequest(for location: Location) -> URLRequest {
		// TODO: More explicit handling of time zone?
		let requestURL = APIClient.baseURL.appendingPathComponent("\(location.latitude),\(location.longitude)")
		return URLRequest(url: requestURL)
	}
	
	func loadCurrentForecast(for location: Location, resultHandler: @escaping ForecastFetchResultHandler) {
		let urlRequest = makeURLRequest(for: location)
		URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			self.handleResponse(data: data, response: response, error: error, result: resultHandler)
			DispatchQueue.main.sync {
				ComplicationController().reloadComplicationTimeline()
			}
		}.resume()
	}
	
	func handleResponse(data: Data?, response: URLResponse?, error: Error?, result: ForecastFetchResultHandler) {
		
		guard error == nil else {
			result(.failure(.unknown))
			return
		}
		
		guard let data = data else {
			result(.failure(.noData))
			return
		}
		
		guard let resultJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
		let currentConditions = resultJSON["currently"] as? [String : Any],
		let resultValue = currentConditions["uvIndex"] as? Double,
		let hourlyForecastWrapper = resultJSON["hourly"] as? [String : Any],
		let rawHourlyForecast = hourlyForecastWrapper["data"] as? [[String : Any]],
		let dailyForecastWrapper = resultJSON["daily"] as? [String : Any],
		let rawDailyForecast = dailyForecastWrapper["data"] as? [[String : Any]] else {
			result(.failure(.badRequest))
			return
		}
				
		var days: [Day] = []
		
		for (index, rawDay) in rawDailyForecast.enumerated() {
			
			guard var newDay = day(from: rawDay) else {
				continue
			}
			
			var nextDay: Day? = nil
			if index < rawDailyForecast.count - 1 {
				nextDay = day(from: rawDailyForecast[index + 1])
			}
			
			let forecasts = hourlyForecasts(in: newDay, nextDay: nextDay, from: rawHourlyForecast)
			newDay.remainingDaytimeForecasts = forecasts.daylightForecasts
			newDay.allForecasts = forecasts.allForecasts
			
			days.append(newDay)
			
		}
				
		let currentUVIndex = UVIndex(uvValue: resultValue)
		
		let dayHighForecast = days.first!.highForecast
		let forecastTimeline = ForecastTimeline(days: days)
		
		DispatchQueue.main.sync {
			let fetchResult = ForecastFetchResult(currentUVIndex: currentUVIndex, dayHighForecast: dayHighForecast, forecastTimeline: forecastTimeline)
			result(.success(fetchResult))
		}
		
	}
	
	func day(from rawDay: [String : Any]) -> Day? {
		
		guard let rawStartDate = rawDay["time"] as? TimeInterval,
			let rawSunriseDate = rawDay["sunriseTime"] as? TimeInterval,
			let rawSunsetDate = rawDay["sunsetTime"] as? TimeInterval,
			let highUVForecastTime = rawDay["uvIndexTime"] as? TimeInterval,
			let highUVForecastValue = rawDay["uvIndex"] as? Double,
			let highTemperature = rawDay["temperatureMax"] as? Double else {
			return nil
		}
		
		let startDate = Date(timeIntervalSince1970: rawStartDate)
		let sunriseDate = Date(timeIntervalSince1970: rawSunriseDate)
		let sunsetDate = Date(timeIntervalSince1970: rawSunsetDate)
		
		let highUVIndex = UVIndex(uvValue: highUVForecastValue)
		let highUVForecastDate = Date(timeIntervalSince1970: highUVForecastTime)
		let highUVForecast = UVForecast(date: highUVForecastDate, uvIndex: highUVIndex, temperature: highTemperature)
		
		return Day(startDate: startDate, sunriseDate: sunriseDate, sunsetDate: sunsetDate, remainingDaytimeForecasts: [], allForecasts: [], highForecast: highUVForecast)
	}
	
	private func hourlyForecasts(in day: Day, nextDay: Day?, from rawForecasts: [[String : Any]]) -> (daylightForecasts: [ForecastTimelineEntry], allForecasts: [ForecastTimelineEntry]) {
		
		var daylightEntries: [ForecastTimelineEntry] = []
		var allEntries: [ForecastTimelineEntry] = []
		
		for rawForecast in rawForecasts {
			
			guard let rawDate = rawForecast["time"] as? TimeInterval else {
				continue
			}
			let date = Date(timeIntervalSince1970: rawDate)
			
			guard date.isInSameDay(as: day.startDate) else {
				continue
			}
			
			guard let rawUVIndex = rawForecast["uvIndex"] as? Double, let temperature = rawForecast["temperature"] as? Double else {
				continue
			}
			
			let uvIndex = UVIndex(uvValue: rawUVIndex)
			let uvForecast = UVForecast(date: date, uvIndex: uvIndex, temperature: temperature)
			
			allEntries.append(uvForecast)
			
			if date > day.sunriseDate && date < day.sunsetDate {
				daylightEntries.append(uvForecast)
			}
			else if date > day.sunsetDate, let nextDay = nextDay {
				let night = Night(date: day.sunsetDate, endDate: nextDay.sunriseDate)
				daylightEntries.append(night)
				break// Don't continue once we reach night
			}
		}
		
		return (daylightForecasts: daylightEntries, allForecasts: allEntries)
				
	}
	
}
