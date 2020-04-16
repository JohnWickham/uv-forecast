//
//  ModularSmallComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class ModularSmallComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateModularSmallColumnsText()
		
		var row1Column1TextProvider: CLKSimpleTextProvider
		var row1Column2TextProvider: CLKSimpleTextProvider
		var row2Column1TextProvider: CLKSimpleTextProvider
		var row2Column2TextProvider: CLKSimpleTextProvider
		
		switch OptionsHelper().complicationDisplayOption {
		case .complicationShowsHighValue:
			row1Column1TextProvider = CLKSimpleTextProvider(text: "UV")
			row1Column1TextProvider.tintColor = currentUVIndex.color
			
			row1Column2TextProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
			row1Column2TextProvider.tintColor = .white
			
			row2Column1TextProvider = CLKSimpleTextProvider(text: "HI")
			row2Column1TextProvider.tintColor = highUVForecast.uvIndex.color
			
			row2Column2TextProvider = CLKSimpleTextProvider(text: "\(highUVForecast.uvIndex.uvValue)")
			row2Column2TextProvider.tintColor = .white
		default:
			row1Column1TextProvider = CLKSimpleTextProvider(text: "UV")
			row1Column1TextProvider.tintColor = currentUVIndex.color
			
			row1Column2TextProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
			row1Column2TextProvider.tintColor = .white
			
			row2Column1TextProvider = CLKSimpleTextProvider(text: nextHourForecast.date.shortTimeString)
			row2Column1TextProvider.tintColor = nextHourForecast.uvIndex.color
			
			row2Column2TextProvider = CLKSimpleTextProvider(text: "\(nextHourForecast.uvIndex.uvValue)")
			row2Column2TextProvider.tintColor = .white
		}
		
		complicationTemplate.row1Column1TextProvider = row1Column1TextProvider
		complicationTemplate.row1Column2TextProvider = row1Column2TextProvider
		complicationTemplate.row2Column1TextProvider = row2Column1TextProvider
		complicationTemplate.row2Column2TextProvider = row2Column2TextProvider
		
		return complicationTemplate
	}
	
	
	
}
