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
	
	@Published var forecastTimeline: ForecastTimeline = ForecastTimeline(days: []) {
		willSet {
			objectWillChange.send()
		}
	}
	
}

extension DataStore {
	
	// TODO: Share more code between foreground API fetching and background data updating
	
	func loadForecastFromAPI(for location: Location) {
		
		APIClient().loadCurrentForecast(for: location) { (result) in
						
			switch result {
				case .failure(let error):
					self.error = error
					NSLog("***ERROR: \(error)")
				case .success(let resultValue):
					self.currentUVIndex = resultValue.currentUVIndex
					self.todayHighForecast = resultValue.dayHighForecast
					self.forecastTimeline = resultValue.forecastTimeline
			}
			
			self.loadingState = (isLoading: false, hasLoaded: true)
			
			ComplicationController().reloadComplicationTimeline()
			
			BackgroundUpdateHelper.scheduleBackgroundUpdate(preferredDate: nil)
			
		}
		
	}
	
}
