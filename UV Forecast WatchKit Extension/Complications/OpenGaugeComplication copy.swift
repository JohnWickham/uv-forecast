//
//  OpenGaugeComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class OpenGaugeComplicationHelper {
	
	class func timelineEntry(for uvIndex: UVIndex) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
		
		let gaugeColors = [
			UVIndex.lowColor,// Green (start)
			UVIndex.moderateColor,// Yellow
			UVIndex.highColor,// Orange
			UVIndex.veryHighColor,// Red
			UVIndex.extremeColor// Purple (stop)
		]
		let gaugeColorLocations: [NSNumber] = [0.0, 0.2, 0.4, 0.6, 1.0]
		let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: gaugeColors, gaugeColorLocations: gaugeColorLocations, fillFraction: Float(uvIndex.value / 13.0))// Using 13 as the max here even though there technically isn't a max.
		complicationTemplate.gaugeProvider = gaugeProvider
		
		complicationTemplate.centerTextProvider = CLKSimpleTextProvider(text: "\(uvIndex.value)")
		complicationTemplate.bottomTextProvider = CLKSimpleTextProvider(text: "UV")
		
		return complicationTemplate
	}
	
}
