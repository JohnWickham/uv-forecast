//
//  ComplicationHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/25/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

protocol ComplicationHelper {
	func complicationTemplate(for currentUVIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTemplate
}

extension ComplicationHelper {
	func timelineEntry(for date: Date, currentUVIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: currentUVIndex, highUVForecast: highUVForecast)
		return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
	}
}
