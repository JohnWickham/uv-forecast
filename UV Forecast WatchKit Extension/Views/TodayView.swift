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
		
	}
	
	private var dataLoadedView: some View {
		ScrollView {
			VStack(alignment: HorizontalAlignment.leading, spacing: 5) {
				currentConditionsHeaderView
				Divider()
				highForecastHeaderView
				Divider()
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
		return HeaderView(title: "High", detail: (todayHighForecast.date.isInCurrentHour ? "Now" : todayHighForecast.date.hourTimeString), uvIndex: todayHighForecast.uvIndex)
	}
	
	var forecastListView: ForecastListView? {
		guard let forecastTimeline = dataStore.forecastTimeline else {
			return nil
		}
		return ForecastListView(timelineEntries: forecastTimeline.hourlyDaylightTimelineEntries)
	}

}

struct TodayView_Previews: PreviewProvider {
	
	static var mockDataStore: DataStore = {
		let store = DataStore(forecastTimeline: mockDataTodayTimeline)
		store.loadingState = (false, true)
		store.currentUVIndex = UVIndex(uvValue: 7.0)
		store.locationManager.locationName = "Charlotte"
		store.todayHighForecast = UVForecast(date: Date(timeIntervalSince1970: 1586368800), uvIndex: UVIndex(uvValue: 11.0), temperature: 72)
		return store
	}()
	
	static var previews: some View {
		TodayView(dataStore: mockDataStore)
	}
}
