//
//  TodayView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct TodayView: View {
	
	@ObservedObject var dataStore: DataStore
	
    var body: some View {
		Group {
			
			if dataStore.loadingState.isLoading {
				LoadingView()
			}
			else if dataStore.error != nil {
				ErrorView(error: dataStore.error!) {
					self.dataStore.findLocationAndLoadForecast()
				}
			}
			else {
				dataLoadedView
			}
			
		}
		.contextMenu(menuItems: {
			Button(action: {
				self.dataStore.findLocationAndLoadForecast()
			}, label: {
				VStack{
					Image(systemName: "arrow.clockwise")
						.font(.title)
					Text("Refresh")
				}
			})
		})
	}
	
	private var dataLoadedView: some View {
		ScrollView {
			VStack(alignment: HorizontalAlignment.leading, spacing: 5) {
				currentConditionsHeaderView
				SeparatorView()
				highForecastHeaderView
				SeparatorView()
				forecastListView
			}
		}
	}
	
	var currentConditionsHeaderView: HeaderView? {
		guard let currentUVIndex = dataStore.currentUVIndex else {
			return nil
		}
		return HeaderView(title: "Now", detail: dataStore.locationManager.locationName, uvIndex: currentUVIndex)
	}
	
	var highForecastHeaderView: HeaderView? {
		guard let todayHighForecast = dataStore.todayHighForecast else {
			return nil
		}
		return HeaderView(title: "High", detail: (todayHighForecast.date.isInCurrentHour ? "Now" : todayHighForecast.date.shortTimeString), uvIndex: todayHighForecast.uvIndex)
	}
	
	var forecastListView: ForecastListView? {
		guard let forecastTimeline = dataStore.forecastTimeline else {
			return nil
		}
		return ForecastListView(timelineEntries: forecastTimeline.hourlyTimelineEntries)
	}
	
//	func loadData() {
//		dataStore.loadingState.isLoading = true
//		dataStore.error = nil
//		locationManager.delegate = self
//		locationManager.getCurrentLocation()
//	}
//
//	func locationManagerDidGetLocation(_ result: Result<CLLocation, LocationError>) {
//		switch result {
//			case .failure(let error):
//				if error != .permissionNotDetermined {
//					self.dataStore.loadingState.isLoading = false
//					self.dataStore.error = error
//				}
//			case .success(let location):
//				self.dataStore.loadForecast(for: Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
//		}
//	}
//
}
