//
//  DataStore.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation
import Combine
import ClockKit

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
	
	@Published var currentUVIndex: UVIndex = UVIndex(uvValue: 0.0) {
		willSet {
			objectWillChange.send()
		}
	}
	
	@Published var todayHighForecast: UVForecast = UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 0.0)) {
	   willSet {
		   objectWillChange.send()
	   }
	}
	
	@Published var hourlyForecasts: [UVForecast] = [] {
	   willSet {
		   objectWillChange.send()
	   }
	}
	
	@Published var dailyForecasts: [UVForecast] = [] {
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
						self.hourlyForecasts = resultValue.currentHourlyForecasts
						self.todayHighForecast = resultValue.highForToday
						self.dailyForecasts = resultValue.dailyForecasts
				}
				
				self.loadingState = (isLoading: false, hasLoaded: true)
				
				ComplicationController().reloadComplicationTimeline()
				
				BackgroundUpdateHelper.scheduleBackgroundUpdate(with: location, preferredDate: nil)
				
			}
			
		}
		
	}
	
}
