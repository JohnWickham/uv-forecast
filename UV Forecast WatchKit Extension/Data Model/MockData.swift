//
//  MockData.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 6/25/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation

let timelineEntries: [ForecastTimelineEntry] = [
	UVForecast(date: Date(timeIntervalSince1970: 1586354400), uvIndex: UVIndex(uvValue: 2.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586358000), uvIndex: UVIndex(uvValue: 5.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586361600), uvIndex: UVIndex(uvValue: 7.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586365200), uvIndex: UVIndex(uvValue: 8.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586368800), uvIndex: UVIndex(uvValue: 11.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586372400), uvIndex: UVIndex(uvValue: 8.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586376000), uvIndex: UVIndex(uvValue: 6.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586379600), uvIndex: UVIndex(uvValue: 4.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586383200), uvIndex: UVIndex(uvValue: 1.0)),
	UVForecast(date: Date(timeIntervalSince1970: 1586386800), uvIndex: UVIndex(uvValue: 0.0)),
	Night(date: Date(timeIntervalSince1970: 1586303400), endDate: Date(timeIntervalSince1970: 1586343600))
]

var days: [Day] {
	var days: [Day] = []
	for i in 0..<8 {
		days.append(Day(startDate: Date() + TimeInterval(86400 * i), sunriseDate: Date(timeIntervalSince1970: 1586257320), sunsetDate: Date(timeIntervalSince1970: 1586303400), daytimeForecasts: timelineEntries, allForecasts: timelineEntries, highForecast: timelineEntries.max() as! UVForecast))
	}
	return days
}

let mockDataTodayTimeline = ForecastTimeline(days: days)
let mockDataForecastTimeline = ForecastTimeline(days: days)
