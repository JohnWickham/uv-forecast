//
//  ComplicationHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/25/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

protocol ComplicationHelper {
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast, complicationIdentifier identifier: ComplicationController.ComplicationIdentifier) -> CLKComplicationTemplate
}

extension ComplicationHelper {
	func timelineEntry(for date: Date, currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast, complicationIdentifier identifier: ComplicationController.ComplicationIdentifier) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: currentUVIndex, nextHourForecast: nextHourForecast, highUVForecast: highUVForecast, complicationIdentifier: identifier)
		return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
	}
}
