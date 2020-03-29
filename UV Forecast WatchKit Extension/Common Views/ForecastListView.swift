//
//  ForecastListView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/28/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct ForecastListView: View {
	
	enum TimeFormat {
		case shortTime, shortDay
	}
	
	var timelineEntries: [ForecastTimelineEntry]
	var showsForecastTimes: Bool = false
	var timeFormat: TimeFormat = .shortTime
	
	var body: some View {
		ForEach(timelineEntries, id: \.date) { entry in
			self.rowFor(entry: entry)
		}
	}
	
	private func rowFor(entry: ForecastTimelineEntry) -> AnyView? {
		
		switch entry {
		case let uvForecast as UVForecast:
			return AnyView(UVForecastTimelineRowView(title: self.formattedTitle(for: entry), detail: (self.showsForecastTimes ? entry.date.shortTimeString : ""), forecast: uvForecast))
		case let night as Night:
			return AnyView(NightTimelineRowView(night: night, sunsetDate: night.date, sunriseDate: night.endDate))
		default:
			return nil
		}
		
	}
	
	private func formattedTitle(for entry: ForecastTimelineEntry) -> String {
		
		switch entry {
		case let night as Night:
			return "\(night.date.timeString)\n\(night.endDate.timeString)"
		default:
			
			switch timeFormat {
			case .shortTime:
				return (entry.date.isAtMidnight ? entry.date.shortWeekDayString.uppercased() + " " : "") + entry.date.shortTimeString
			case .shortDay:
				return (entry.date.isToday ? "Today" : entry.date.shortWeekDayString).uppercased()
			}
			
		}
				
	}
	
}
