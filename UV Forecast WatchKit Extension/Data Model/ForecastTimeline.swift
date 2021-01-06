//
//  ForecastTimeline.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/28/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation

struct Day {
	
	var startDate: Date
	var endDate: Date {
		return Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
	}
	
	var sunriseDate: Date
	var sunsetDate: Date
	
	var remainingDaytimeForecasts: [ForecastTimelineEntry]
	var allForecasts: [ForecastTimelineEntry]
	var highForecast: UVForecast
	
}

struct ForecastTimeline {
	
	var days: [Day]
	
	var allHourlyTimelineEntries: [ForecastTimelineEntry] {
		var cumulativeForecasts: [ForecastTimelineEntry] = []
		days.forEach { (day) in
			cumulativeForecasts += day.allForecasts
		}
		return cumulativeForecasts
	}
	
	var hourlyDaylightTimelineEntries: [ForecastTimelineEntry] {
		var cumulativeForecasts: [ForecastTimelineEntry] = []
		days.forEach { (day) in
			cumulativeForecasts += day.remainingDaytimeForecasts
		}
		return cumulativeForecasts
	}
	
	var highDailyForecast: UVForecast? {
		let dailyHighs = days.compactMap({ $0.highForecast })
		return dailyHighs.max()
	}
	
	var currentUVForecast: UVForecast? {
		return hourlyDaylightTimelineEntries.compactMap { (entry) -> UVForecast? in
			entry as? UVForecast
		}.first
	}
	
	func timelineEntry(after entry: UVForecast) -> ForecastTimelineEntry? {
		
		let forecastEntries = hourlyDaylightTimelineEntries.compactMap { (timelineEntry) -> UVForecast? in
			timelineEntry as? UVForecast
		}
		
		return forecastEntries.first { (forecast) -> Bool in
			forecast.date > entry.date
		}
		
	}
	
}

class ForecastTimelineEntry: Comparable {
	
	var date: Date
	
	init(date: Date) {
		self.date = date
	}
	
	static func == (lhs: ForecastTimelineEntry, rhs: ForecastTimelineEntry) -> Bool {
		
		if let lhs = lhs as? UVForecast, let rhs = rhs as? UVForecast {
			return lhs.uvIndex.uvValue == rhs.uvIndex.uvValue && lhs.date == rhs.date
		}
		
		return lhs.date == rhs.date
	}
	
	static func < (lhs: ForecastTimelineEntry, rhs: ForecastTimelineEntry) -> Bool {
		
		if let lhs = lhs as? UVForecast, let rhs = rhs as? UVForecast {
			return lhs.uvIndex.uvValue < rhs.uvIndex.uvValue
		}
		
		return lhs.date < rhs.date
	}
	
}
