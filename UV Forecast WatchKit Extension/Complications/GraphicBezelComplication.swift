//
//  GraphicBezelComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GraphicBezelComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for uvIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateGraphicBezelCircularText()
		
		complicationTemplate.circularTemplate = OpenGaugeComplicationHelper().complicationTemplate(for: uvIndex, highUVForecast: highUVForecast) as! CLKComplicationTemplateGraphicCircular
		
		complicationTemplate.textProvider = CLKSimpleTextProvider(text: "Now \(uvIndex.uvValue) High \(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.shortTimeString)")
				
		return complicationTemplate
	}
	
}
