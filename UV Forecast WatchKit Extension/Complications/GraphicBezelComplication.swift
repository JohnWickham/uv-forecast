//
//  GraphicBezelComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GraphicBezelComplicationHelper {
	
	class func timelineEntry(for currentUVIndex: UVIndex, highUVForecast: Forecast) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: currentUVIndex, highUVForecast: highUVForecast)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex, highUVForecast: Forecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateGraphicBezelCircularText()
		
		complicationTemplate.circularTemplate = OpenGaugeComplicationHelper.complicationTemplate(for: uvIndex)
		
		complicationTemplate.textProvider = CLKSimpleTextProvider(text: "Now \(uvIndex.uvValue) High \(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.shortTimeString)")
				
		return complicationTemplate
	}
	
}
