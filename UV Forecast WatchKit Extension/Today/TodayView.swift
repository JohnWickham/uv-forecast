//
//  TodayView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct TodayView: View, LocationManagerDelegate {
	
	@ObservedObject var locationManager = LocationManager()
	@ObservedObject var dataStore: DataStore
	
    var body: some View {
		Group {
			
			if dataStore.loadingState.isLoading {
				LoadingView()
			}
			else if dataStore.error != nil {
				ErrorView(error: dataStore.error!) {
					self.loadData()
				}
			}
			else {
				dataLoadedView
			}
			
		}
		.contextMenu(menuItems: {
			Button(action: {
				self.loadData()
			}, label: {
				VStack{
					Image(systemName: "arrow.clockwise")
						.font(.title)
					Text("Refresh")
				}
			})
		})
		.onAppear {
			if !self.dataStore.loadingState.hasLoaded {
				self.loadData()
			}
		}
	}
	
	private var dataLoadedView: some View {
		ScrollView {
			VStack(alignment: HorizontalAlignment.leading, spacing: 5) {
				HeaderView(title: "Now", detail: locationManager.locationName, uvIndex: dataStore.currentUVIndex)
				
				SeparatorView()
				
				HeaderView(title: "High", detail: dataStore.todayHighForecast.highIndexDate!.shortTimeString, uvIndex: dataStore.todayHighForecast.uvIndex)
				
				SeparatorView()
				
				ForEach(dataStore.hourlyForecast.forecasts, id: \.date) { forecast in
					ForecastRowView(uvIndex: forecast.uvIndex, title: (forecast.date.isAtMidnight ? forecast.date.shortWeekDayString.uppercased() + " " : "") + forecast.date.shortTimeString, detail: "")
				}
				
			}
		}
	}
	
	func loadData() {
		dataStore.loadingState.isLoading = true
		dataStore.error = nil
		locationManager.delegate = self
		locationManager.getCurrentLocation()
	}
	
	func locationManagerDidGetLocation(_ result: Result<CLLocation, LocationError>) {
		switch result {
			case .failure(let error):
				if error != .permissionNotDetermined {
					self.dataStore.loadingState.isLoading = false
					self.dataStore.error = error
				}
			case .success(let location):
				self.dataStore.loadForecastFromAPI(for: (location.coordinate.latitude, location.coordinate.longitude))
		}
	}
	
}
