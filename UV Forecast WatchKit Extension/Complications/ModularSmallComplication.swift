//
//  ModularSmallComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class ModularSmallComplicationHelper {
	
	class func timelineEntry(for date: Date, uvIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex, highUVForecast: highUVForecast)
		return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateModularSmallColumnsText()
		
		let row1Column1TextProvider = CLKSimpleTextProvider(text: "UV")
		row1Column1TextProvider.tintColor = uvIndex.color
		complicationTemplate.row1Column1TextProvider = row1Column1TextProvider
		
		let row1Column2TextProvider = CLKSimpleTextProvider(text: "\(uvIndex.uvValue)")
		row1Column2TextProvider.tintColor = .white
		complicationTemplate.row1Column2TextProvider = row1Column2TextProvider
		
		let row2Column1TextProvider = CLKSimpleTextProvider(text: "HI")
		row2Column1TextProvider.tintColor = highUVForecast.uvIndex.color
		complicationTemplate.row2Column1TextProvider = row2Column1TextProvider
		
		let row2Column2TextProvider = CLKSimpleTextProvider(text: "\(highUVForecast.uvIndex.uvValue)")
		row2Column2TextProvider.tintColor = .white
		complicationTemplate.row2Column2TextProvider = row2Column2TextProvider
		
		return complicationTemplate
	}
	
}
