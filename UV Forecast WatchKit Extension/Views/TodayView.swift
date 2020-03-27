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
				
				HeaderView(title: "High", detail: (dataStore.todayHighForecast.date.isInCurrentHour ? "Now" : dataStore.todayHighForecast.date.shortTimeString), uvIndex: dataStore.todayHighForecast.uvIndex)
				
				SeparatorView()
				
				ForEach(dataStore.hourlyForecasts, id: \.date) { forecast in
					self.timelineRowView(for: forecast)
				}
				
			}
		}
	}
	
	private func timelineRowView(for entry: ForecastTimelineEntry) -> TimelineRowView {
		let titleTime = (entry as? SunEvent == nil) ? entry.date.shortTimeString : entry.date.timeString
		let title = (entry.date.isAtMidnight ? entry.date.shortWeekDayString.uppercased() + " " : "") + titleTime
		return TimelineRowView(timelineEntry: entry, title: title, detail: "")
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
				self.dataStore.loadForecastFromAPI(for: Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
		}
	}
	
}
