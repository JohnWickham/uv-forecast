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
				highForecastHeaderView
				Divider()
				timelineList
			}
		}
	}
	
	var timelineList: ForecastListView? {
		
		guard let forecastTimeline = dataStore.forecastTimeline else {
			return nil
		}
		
		let highForecasts = forecastTimeline.days.compactMap { (day) -> UVForecast? in
			day.highForecast
		}
		
		return ForecastListView(timelineEntries: highForecasts, showsForecastTimes: true, timeFormat: .shortDay)
	}
	
	private var highForecastHeaderView: HeaderView? {
		if let highForecast = dataStore.forecastTimeline?.highDailyForecast {
			return HeaderView(title: "8-Day High", uvIndex: highForecast.uvIndex)
		}
		return nil
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
				dataStore.loadForecast(for: Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
		}
	}
}

struct ForecastView_Previews: PreviewProvider {
	
	static var mockDataStore: DataStore = {
		let store = DataStore(forecastTimeline: mockDataTodayTimeline)
		store.loadingState = (false, true)
		store.currentUVIndex = UVIndex(uvValue: 7.0)
		store.locationManager.locationName = "Charlotte"
		store.todayHighForecast = UVForecast(date: Date(timeIntervalSince1970: 1586368800), uvIndex: UVIndex(uvValue: 11.0))
		return store
	}()
	
	static var previews: some View {
		ForecastView(dataStore: mockDataStore)
	}
}
