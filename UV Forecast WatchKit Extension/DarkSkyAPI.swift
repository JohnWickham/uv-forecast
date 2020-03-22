//
//  DarkSkyAPI.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI
import Combine

enum APIClientState {
	case loading
	case failed(error: Error)
	case loaded
}

enum APIError: LocalizedError {
    case request(code: Int, error: Error?)
	case noData
	case badRequest
    case unknown
	
	var errorDescription: String? {
		switch self {
		default:
			return "An error occurred loading UV Index information."
		}
	}
}

class APIClient {
	
	static let APIKey: String = "accbf73888a364be5659f3fb1f453e8d"
	static let baseURL: URL = URL(string: "https://api.darksky.net/forecast/\(APIClient.APIKey)/")!
	
	var state: APIClientState = .loading
	
	typealias ForecastFetchResult = (currentUVIndex: UVIndex, currentHourlyForecasts: [Forecast], highForToday: Forecast, dailyForecasts: [Forecast])
	
	func loadCurrentForecast(for location: (latitude: Double, longitude: Double), result: @escaping ((_ result: Result<ForecastFetchResult, APIError>) -> Void)) {
		
		let requestURL = APIClient.baseURL.appendingPathComponent("\(location.latitude),\(location.longitude)")
		let request = URLRequest(url: requestURL)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			guard error == nil else {
				result(.failure(.unknown))
				return
			}
			
			guard let data = data else {
				result(.failure(.noData))
				return
			}
			
			guard let resultJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
				result(.failure(.badRequest))
				return
			}
			
			guard let currentConditions = resultJSON["currently"] as? [String : Any], let resultValue = currentConditions["uvIndex"] as? Double, let hourlyForecastWrapper = resultJSON["hourly"] as? [String : Any], let rawHourlyForecast = hourlyForecastWrapper["data"] as? [[String : Any]], let dailyForecastWrapper = resultJSON["daily"] as? [String : Any], let rawDailyForecast = dailyForecastWrapper["data"] as? [[String : Any]] else {
				result(.failure(.badRequest))
				return
			}
			
			let currentUVIndex = UVIndex(value: resultValue)
			
			let currentHourlyForecast = rawHourlyForecast.compactMap { (rawForecast) -> Forecast? in
				
				guard let rawDate = rawForecast["time"] as? TimeInterval else {
					return nil
				}
				let date = Date(timeIntervalSince1970: rawDate)
				
				guard let rawUVIndex = rawForecast["uvIndex"] as? Double else {
					return nil
				}
				let uvIndex = UVIndex(value: rawUVIndex)
				
				return Forecast(date: date, uvIndex: uvIndex)
			}
			
			let dailyForecastList = rawDailyForecast.compactMap { (rawForecast) -> Forecast? in
				
				guard let rawDate = rawForecast["time"] as? TimeInterval else {
					return nil
				}
				let date = Date(timeIntervalSince1970: rawDate)
				
				guard let rawUVIndex = rawForecast["uvIndex"] as? Double else {
					return nil
				}
				let uvIndex = UVIndex(value: rawUVIndex)
				
				var forecast = Forecast(date: date, uvIndex: uvIndex)
				
				if let rawHighIndexDate = rawForecast["uvIndexTime"] as? TimeInterval {
					forecast.highIndexDate = Date(timeIntervalSince1970: rawHighIndexDate)
				}
				
				return forecast
			}
			
			let highForToday = dailyForecastList.first!
			
			result(.success(ForecastFetchResult(currentUVIndex, currentHourlyForecast, highForToday, dailyForecastList)))
			
		}.resume()
		
	}
	
}
