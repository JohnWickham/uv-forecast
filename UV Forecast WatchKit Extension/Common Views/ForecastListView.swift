//
//  ForecastListView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/28/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct TodayListView: View {
	
	var timelineEntries: [ForecastTimelineEntry]
	
	var body: some View {
		ForEach(timelineEntries, id: \.date) { entry -> AnyView? in
			
			switch entry {
			case let uvForecast as UVForecast:
				return AnyView(UVForecastTimelineRowView(title: (entry.date.isAtMidnight ? entry.date.shortWeekDayString.uppercased() + " " : "") + entry.date.hourTimeString, detail: uvForecast.formattedTemperatureString ?? "", forecast: uvForecast))
			case let night as Night:
				return AnyView(NightTimelineRowView(night: night, sunsetDate: night.date, sunriseDate: night.endDate))
			default:
				return nil
			}
			
		}
	}
}

struct ForecastListView: View {
	
	var timelineEntries: [ForecastTimelineEntry]
	
	var body: some View {
		ForEach(timelineEntries, id: \.date) { entry -> AnyView? in
			
			switch entry {
			case let uvForecast as UVForecast:
				return AnyView(UVForecastTimelineRowView(title: (entry.date.isToday ? "Today" : entry.date.shortWeekDayString).uppercased(), detail: entry.date.hourTimeString, forecast: uvForecast))
			default:
				return nil
			}
			
		}
	}
	
}
