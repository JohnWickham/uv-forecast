//
//  ModularSmallComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class ModularSmallComplicationHelper {
	
	class func timelineEntry(for uvIndex: UVIndex) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateModularSmallSimpleText()
		
		let textProvider = CLKSimpleTextProvider(text: "\(uvIndex.value)")
		textProvider.tintColor = uvIndex.color
		complicationTemplate.textProvider = textProvider
		
		return complicationTemplate
	}
	
}
