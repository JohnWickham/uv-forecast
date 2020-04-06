//
//  DataStore.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Combine
import ClockKit
import CoreLocation

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
	
	@Published var currentUVIndex: UVIndex? {
		willSet {
			objectWillChange.send()
		}
	}
	
	@Published var todayHighForecast: UVForecast? {
	   willSet {
		   objectWillChange.send()
	   }
	}
	
	@Published var forecastTimeline: ForecastTimeline? {
		willSet {
			objectWillChange.send()
		}
	}
	
	lazy var locationManager: LocationManager = {
		let manager = LocationManager()
		manager.delegate = self
		return manager
	}()
	
	var lastSavedLocation: Location? {
		let userDefaults = UserDefaults.standard
		guard let latitude = userDefaults["location.latitude"] as? Double, let longitude = userDefaults["location.longitude"] as? Double else {
			return nil
		}
		return Location(latitude: latitude, longitude: longitude)
	}
	
}

extension DataStore {
		
	func findLocationAndLoadForecast() {
		error = nil
		locationManager.getCurrentLocation()
	}
	
	func loadForecastForLastKnownLocation() {
		
		let userDefaults = UserDefaults.standard
		guard let latitude = userDefaults["location.latitude"] as? Double, let longitude = userDefaults["location.longitude"] as? Double else {
			return
		}
		
		error = nil
		
		let location = Location(latitude: latitude, longitude: longitude)
		loadForecast(for: location)
		
	}
	
	func loadForecast(for location: Location) {
		
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
			
			ExtensionDelegate.scheduleNextAppBackgroundRefresh()
			
		}
		
	}
	
}

extension DataStore: LocationManagerDelegate {
	
	func locationManagerDidGetLocation(_ result: Result<CLLocation, LocationError>) {
		
		switch result {
			case .failure(let error):
				
				if error != .permissionNotDetermined {
					self.loadingState.isLoading = false
					self.error = error
				}
			
			case .success(let location):
				
				let location = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
				
				// Store the location in UserDefaults
				let userDefaults = UserDefaults.standard
				userDefaults["location.latitude"] = location.latitude
				userDefaults["location.longitude"] = location.longitude
				
				self.loadForecast(for: location)
		}
		
	}
	
}
