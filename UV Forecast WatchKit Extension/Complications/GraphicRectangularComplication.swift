//
//  GraphicRectangularComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GraphicRectangularComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for uvIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast, complicationIdentifier: ComplicationController.ComplicationIdentifier) -> CLKComplicationTemplate {
		
		let titleTextProvider = CLKSimpleTextProvider(text: "UV Forecast")
		titleTextProvider.tintColor = .white
		let headerTextProvider = titleTextProvider
		
		var body1Text: String
		var body2Text: String
		
		var body1Color: UIColor
		var body2Color: UIColor
		
		switch complicationIdentifier {
		case .maxUVIndexForecast:
			body1Text = "Now: \(uvIndex.uvValue) \(uvIndex.description)"
			body2Text = "High: \(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.hourTimeString)"
			body1Color = uvIndex.color
			body2Color = highUVForecast.uvIndex.color
		default:
			body1Text = "Now: \(uvIndex.uvValue) \(uvIndex.description)"
			body2Text = "\(nextHourForecast.date.hourTimeString): \(nextHourForecast.uvIndex.uvValue) \(nextHourForecast.uvIndex.description)"
			body1Color = uvIndex.color
			body2Color = nextHourForecast.uvIndex.color
		}

		let currentForecastTextProvider = CLKSimpleTextProvider(text: body1Text)
		currentForecastTextProvider.tintColor = body1Color
		let body1TextProvider = currentForecastTextProvider
		
		let highForecastTextProvider = CLKSimpleTextProvider(text: body2Text)
		highForecastTextProvider.tintColor = body2Color
		let body2TextProvider = highForecastTextProvider
				
		return CLKComplicationTemplateGraphicRectangularStandardBody(headerImageProvider: nil, headerTextProvider: headerTextProvider, body1TextProvider: body1TextProvider, body2TextProvider: body2TextProvider)
	}
	
}
