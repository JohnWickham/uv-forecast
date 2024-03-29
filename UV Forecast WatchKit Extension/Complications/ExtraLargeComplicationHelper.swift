//
//  ExtraLargeComplicationHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class ExtraLargeComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast, complicationIdentifier: ComplicationController.ComplicationIdentifier) -> CLKComplicationTemplate {	
		let valueTextProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
		valueTextProvider.tintColor = currentUVIndex.color
		
		return CLKComplicationTemplateExtraLargeSimpleText(textProvider: valueTextProvider)
	}
	
}
