//
//  OpenGaugeComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class OpenGaugeComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let gaugeColors = [
			UVIndex.lowColor,
			UVIndex.moderateColor,
			UVIndex.highColor,
			UVIndex.veryHighColor,
			UVIndex.extremeColor
		]
		let gaugeColorLocations: [NSNumber] = [0.0, 0.2, 0.4, 0.6, 1.0]
		let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: gaugeColors, gaugeColorLocations: gaugeColorLocations, fillFraction: Float(currentUVIndex.uvValue / 13.0))// Using 13 as the max here even though there technically isn't a max.
		
		let centerTextProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
		centerTextProvider.tintColor = currentUVIndex.color
		
		let bottomTextProvider = CLKSimpleTextProvider(text: "UV")
		
		return CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText(gaugeProvider: gaugeProvider, bottomTextProvider: bottomTextProvider, centerTextProvider: centerTextProvider)
	}
	
}
