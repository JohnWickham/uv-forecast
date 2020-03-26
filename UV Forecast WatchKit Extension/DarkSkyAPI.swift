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
	
	typealias ForecastFetchResult = (currentUVIndex: UVIndex, currentHourlyForecasts: [UVForecast], highForToday: UVForecast, dailyForecasts: [UVForecast])
	typealias ForecastFetchResultHandler = ((_ result: Result<ForecastFetchResult, APIError>) -> Void)
	
	func makeURLRequest(for location: Location) -> URLRequest {
		let requestURL = APIClient.baseURL.appendingPathComponent("\(location.latitude),\(location.longitude)")
		return URLRequest(url: requestURL)
	}
	
	func loadCurrentForecast(for location: Location, resultHandler: @escaping ForecastFetchResultHandler) {
		let urlRequest = makeURLRequest(for: location)
		URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			self.handleResponse(data: data, response: response, error: error, result: resultHandler)
			ComplicationController().reloadComplicationTimeline()
		}.resume()
	}
	
	func scheduleBackgroundUpdate(for location: Location) {
		
		let sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "com.Wickham.UV-Forecast.BackgroundUpdate")
		sessionConfiguration.sessionSendsLaunchEvents = true
		let backgroundSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
		
		let urlRequest = makeURLRequest(for: location)
		backgroundSession.downloadTask(with: urlRequest).resume()
		
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
		
		guard let resultJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
			result(.failure(.badRequest))
			return
		}
		
		guard let currentConditions = resultJSON["currently"] as? [String : Any], let resultValue = currentConditions["uvIndex"] as? Double, let hourlyForecastWrapper = resultJSON["hourly"] as? [String : Any], let rawHourlyForecast = hourlyForecastWrapper["data"] as? [[String : Any]], let dailyForecastWrapper = resultJSON["daily"] as? [String : Any], let rawDailyForecast = dailyForecastWrapper["data"] as? [[String : Any]] else {
			result(.failure(.badRequest))
			return
		}
		
		let currentUVIndex = UVIndex(uvValue: resultValue)
		
		let currentHourlyForecast = rawHourlyForecast.compactMap { (rawForecast) -> UVForecast? in
			
			guard let rawDate = rawForecast["time"] as? TimeInterval else {
				return nil
			}
			let date = Date(timeIntervalSince1970: rawDate)
			
			guard let rawUVIndex = rawForecast["uvIndex"] as? Double else {
				return nil
			}
			let uvIndex = UVIndex(uvValue: rawUVIndex)
			
			return UVForecast(date: date, uvIndex: uvIndex)
		}
		
		let dailyForecastList = rawDailyForecast.compactMap { (rawForecast) -> UVForecast? in
			
			guard let rawDate = rawForecast["time"] as? TimeInterval else {
				return nil
			}
			let date = Date(timeIntervalSince1970: rawDate)
			
			guard let rawUVIndex = rawForecast["uvIndex"] as? Double else {
				return nil
			}
			let uvIndex = UVIndex(uvValue: rawUVIndex)
			
			var forecast = UVForecast(date: date, uvIndex: uvIndex)
			
			if let rawHighIndexDate = rawForecast["uvIndexTime"] as? TimeInterval {
				forecast.date = Date(timeIntervalSince1970: rawHighIndexDate)
			}
			
			return forecast
		}
		
		let highForToday = dailyForecastList.first!
		
		result(.success(ForecastFetchResult(currentUVIndex, currentHourlyForecast, highForToday, dailyForecastList)))
		
	}
	
}

extension APIClient: URLSessionDownloadDelegate {
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		
		print("Background download finished; parsing data…")
		
        do {
			
            let data = try Data(contentsOf: location)
			handleResponse(data: data, response: downloadTask.response, error: downloadTask.error, result: { (result) in
				
				DispatchQueue.main.sync {
					switch result {
					case .failure(let error):
						print("Background download task failed: ", error)
					case .success(let fetchResult):
						DataStore.shared.currentUVIndex = fetchResult.currentUVIndex
						DataStore.shared.hourlyForecasts = fetchResult.currentHourlyForecasts
						DataStore.shared.todayHighForecast = fetchResult.highForToday
						DataStore.shared.dailyForecasts = fetchResult.dailyForecasts
					}
					
					print("Updated data store.")
					
					BackgroundUpdateHelper.didCompleteBackgroundRefreshFetch()
				}
				
			})
			
        } catch {
            print("\(error.localizedDescription)")
        }
    }
	
}
