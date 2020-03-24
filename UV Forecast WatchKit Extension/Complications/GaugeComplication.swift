//
//  OpenGaugeComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GaugeComplicationHelper {
	
	class func timelineEntry(for date: Date, uvIndex: UVIndex) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex)
		return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateGraphicCornerGaugeText()
		
		let gaugeColors = [
			UVIndex.lowColor,// Green (start)
			UVIndex.moderateColor,// Yellow
			UVIndex.highColor,// Orange
			UVIndex.veryHighColor,// Red
			UVIndex.extremeColor// Purple (stop)
		]
		let gaugeColorLocations: [NSNumber] = [0.0, 0.2, 0.4, 0.6, 1.0]
		let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: gaugeColors, gaugeColorLocations: gaugeColorLocations, fillFraction: Float(uvIndex.uvValue / 13.0))// Using 13 as the max here even though there technically isn't a max.
		complicationTemplate.gaugeProvider = gaugeProvider
		
		let outerTextProvider = CLKSimpleTextProvider(text: "\(uvIndex.uvValue)")
		outerTextProvider.tintColor = uvIndex.color
		complicationTemplate.outerTextProvider = outerTextProvider
		
		let leadingTextProvider = CLKSimpleTextProvider(text: "UV")
		leadingTextProvider.tintColor = UVIndex.lowColor
		complicationTemplate.leadingTextProvider = leadingTextProvider
		
		return complicationTemplate
	}
	
}
