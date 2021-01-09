//
//  MockData.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 6/25/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation

let timelineEntries: [ForecastTimelineEntry] = [
	UVForecast(date: Date(timeIntervalSince1970: 1586354400), uvIndex: UVIndex(uvValue: 2.0), temperature: 68),
	UVForecast(date: Date(timeIntervalSince1970: 1586358000), uvIndex: UVIndex(uvValue: 5.0), temperature: 72),
	UVForecast(date: Date(timeIntervalSince1970: 1586361600), uvIndex: UVIndex(uvValue: 7.0), temperature: 75),
	UVForecast(date: Date(timeIntervalSince1970: 1586365200), uvIndex: UVIndex(uvValue: 8.0), temperature: 81),
	UVForecast(date: Date(timeIntervalSince1970: 1586368800), uvIndex: UVIndex(uvValue: 11.0), temperature: 89),
	UVForecast(date: Date(timeIntervalSince1970: 1586372400), uvIndex: UVIndex(uvValue: 8.0), temperature: 91),
	UVForecast(date: Date(timeIntervalSince1970: 1586376000), uvIndex: UVIndex(uvValue: 6.0), temperature: 84),
	UVForecast(date: Date(timeIntervalSince1970: 1586379600), uvIndex: UVIndex(uvValue: 4.0), temperature: 79),
	UVForecast(date: Date(timeIntervalSince1970: 1586383200), uvIndex: UVIndex(uvValue: 1.0), temperature: 72),
	UVForecast(date: Date(timeIntervalSince1970: 1586386800), uvIndex: UVIndex(uvValue: 0.0), temperature: 69),
	Night(date: Date(timeIntervalSince1970: 1586303400), endDate: Date(timeIntervalSince1970: 1586343600))
]

var days: [Day] {
	var days: [Day] = []
	for i in 0..<8 {
		days.append(Day(startDate: Date() + TimeInterval(86400 * i), sunriseDate: Date(timeIntervalSince1970: 1586257320), sunsetDate: Date(timeIntervalSince1970: 1586303400), remainingDaytimeForecasts: timelineEntries, allForecasts: timelineEntries, highForecast: timelineEntries.max() as! UVForecast))
	}
	return days
}

let mockDataTodayTimeline = ForecastTimeline(days: days)
let mockDataForecastTimeline = ForecastTimeline(days: days)
