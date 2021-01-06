//
//  GraphicBezelComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class GraphicBezelComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for uvIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let circularTemplate = OpenGaugeComplicationHelper().complicationTemplate(for: uvIndex, nextHourForecast: nextHourForecast, highUVForecast: highUVForecast) as! CLKComplicationTemplateGraphicCircular
		
		var bezelText: String
		
		switch OptionsHelper().complicationDisplayOption {
		case .complicationShowsHighValue:
			 bezelText = "Now \(uvIndex.uvValue) High \(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.hourTimeString)"
		default:
			bezelText = "Now \(uvIndex.uvValue) \(nextHourForecast.date.hourTimeString) \(nextHourForecast.uvIndex.uvValue)"
		}
		
		let textProvider = CLKSimpleTextProvider(text: bezelText)
				
		return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate, textProvider: textProvider)
	}
	
}
