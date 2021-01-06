//
//  OpenGaugeComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GaugeComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let gaugeColors = [
			UVIndex.lowColor,// Green (start)
			UVIndex.moderateColor,// Yellow
			UVIndex.highColor,// Orange
			UVIndex.veryHighColor,// Red
			UVIndex.extremeColor// Purple (stop)
		]
		let gaugeColorLocations: [NSNumber] = [0.0, 0.2, 0.4, 0.6, 1.0]
		let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: gaugeColors, gaugeColorLocations: gaugeColorLocations, fillFraction: Float(currentUVIndex.uvValue / 13.0))// Using 13 as the max here even though there technically isn't a max.
		
		let outerTextProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
		
		let leadingTextProvider = CLKSimpleTextProvider(text: "UV")
		leadingTextProvider.tintColor = currentUVIndex.color
		
		return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider, leadingTextProvider: leadingTextProvider, trailingTextProvider: nil, outerTextProvider: outerTextProvider)
	}
	
}
