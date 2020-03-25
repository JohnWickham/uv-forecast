//
//  ForecastView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

// TODO: ForecastView and TodayView are basically the exact same. Try to share a little more code between the two

struct ForecastView: View, LocationManagerDelegate {
	
	@ObservedObject var locationManager = LocationManager()
	@ObservedObject var dataStore: DataStore
	
    var body: some View {
		
		Group {
			
			if self.dataStore.loadingState.isLoading {
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
	
	var dataLoadedView: some View {
		ScrollView {
			VStack(alignment: HorizontalAlignment.leading, spacing: 5) {
				HeaderView(title: "8-Day High", uvIndex: dataStore.dailyForecasts.max()!.uvIndex)
				
				SeparatorView()
				
				ForEach(dataStore.dailyForecasts, id: \.date) { forecast in
					ForecastRowView(uvIndex: forecast.uvIndex, title: (forecast.date.isToday ? "Today" : forecast.date.shortWeekDayString).uppercased(), detail: forecast.date.shortTimeString)
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
				dataStore.loadForecastFromAPI(for: (location.coordinate.latitude, location.coordinate.longitude))
		}
	}
	
//	func loadForecastFromAPI(for location: CLLocation) {
//		APIClient().loadCurrentForecast(for: (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { (result) in
//			switch result {
//				case .failure(let error):
//					self.dataStore.error = error
//				case .success(let resultValue):
//					self.dataStore.eightDayForecast = resultValue.dailyForecastList
//			}
//			self.dataStore.loadingState = (isLoading: false, hasLoaded: true)
//		}
//	}
}
