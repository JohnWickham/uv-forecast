//
//  GraphicRectangularComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GraphicRectangularComplicationHelper {
	
	class func timelineEntry(for currentUVIndex: UVIndex, highUVForecast: Forecast) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: currentUVIndex, highUVForecast: highUVForecast)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex, highUVForecast: Forecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateGraphicRectangularStandardBody()
		
		let titleTextProvider = CLKSimpleTextProvider(text: "UV Forecast")
		titleTextProvider.tintColor = .white
		complicationTemplate.headerTextProvider = titleTextProvider

		let currentForecastTextProvider = CLKSimpleTextProvider(text: "Now: \(uvIndex.value) \(uvIndex.description)")
		currentForecastTextProvider.tintColor = uvIndex.color
		complicationTemplate.body1TextProvider = currentForecastTextProvider
		
		let highForecastTextProvider = CLKSimpleTextProvider(text: "High: \(highUVForecast.uvIndex.value) at \(highUVForecast.highIndexDate!.shortTimeString)")
		highForecastTextProvider.tintColor = highUVForecast.uvIndex.color
		complicationTemplate.body2TextProvider = highForecastTextProvider
				
		return complicationTemplate
	}
	
}
