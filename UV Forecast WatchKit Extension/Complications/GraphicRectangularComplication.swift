//
//  GraphicRectangularComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GraphicRectangularComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for uvIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateGraphicRectangularStandardBody()
		
		let titleTextProvider = CLKSimpleTextProvider(text: "UV Forecast")
		titleTextProvider.tintColor = .white
		complicationTemplate.headerTextProvider = titleTextProvider

		let currentForecastTextProvider = CLKSimpleTextProvider(text: "Now: \(uvIndex.uvValue) \(uvIndex.description)")
		currentForecastTextProvider.tintColor = uvIndex.color
		complicationTemplate.body1TextProvider = currentForecastTextProvider
		
		let highForecastTextProvider = CLKSimpleTextProvider(text: "High: \(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.shortTimeString)")
		highForecastTextProvider.tintColor = highUVForecast.uvIndex.color
		complicationTemplate.body2TextProvider = highForecastTextProvider
				
		return complicationTemplate
	}
	
}
