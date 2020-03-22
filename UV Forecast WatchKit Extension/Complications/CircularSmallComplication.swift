//
//  CircularSmallComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class CircularSmallComplicationHelper {
	
	class func timelineEntry(for uvIndex: UVIndex) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateCircularSmallSimpleText()
		complicationTemplate.textProvider = CLKSimpleTextProvider(text: "\(uvIndex.value)")
		
		return complicationTemplate
	}
	
}
