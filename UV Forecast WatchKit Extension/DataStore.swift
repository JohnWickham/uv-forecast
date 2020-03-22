//
//  DataStore.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation
import Combine

class DataStore: ObservableObject {
	
	static let shared = DataStore()
	
    let objectWillChange = PassthroughSubject<Void, Never>()
	
	@Published var loadingState = (isLoading: true, hasLoaded: false) {
	   willSet {
		   objectWillChange.send()
	   }
	}
	
	@Published var error: Error? {
	   willSet {
		   objectWillChange.send()
	   }
	}
	
	@Published var currentUVIndex: UVIndex = UVIndex(value: 0.0) {
		willSet {
			objectWillChange.send()
		}
	}
	
	@Published var todayHighForecast: Forecast = Forecast(date: Date(), highIndexDate: nil, uvIndex: UVIndex(value: 0.0)) {
	   willSet {
		   objectWillChange.send()
	   }
	}
	
	@Published var hourlyForecast: ForecastList = ForecastList(forecasts: []) {
	   willSet {
		   objectWillChange.send()
	   }
	}
	
	@Published var dailyForecast: ForecastList = ForecastList(forecasts: []) {
		willSet {
			objectWillChange.send()
		}
	}
	
}

extension DataStore {
	
	func loadForecastFromAPI(for location: (latitude: Double, longitude: Double)) {
		
		APIClient().loadCurrentForecast(for: location) { (result) in
			
			DispatchQueue.main.sync {
				switch result {
					case .failure(let error):
						self.error = error
					case .success(let resultValue):
						self.currentUVIndex = resultValue.currentUVIndex
						self.hourlyForecast = resultValue.currentHourlyForecastList
						self.todayHighForecast = resultValue.highForToday
						self.dailyForecast = resultValue.dailyForecastList
				}
				
				//self.loadingState = (isLoading: false, hasLoaded: true)
			}
			
		}
		
	}
	
}
