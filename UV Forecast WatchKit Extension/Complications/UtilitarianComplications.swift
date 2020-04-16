//
//  UtilitarianSmall.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class UtilitarianSmallComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
		
		let textProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
		textProvider.tintColor = currentUVIndex.color
		complicationTemplate.textProvider = textProvider
		
		let imageProvider = CLKImageProvider(onePieceImage: UIImage(systemName: "sun.max.fill")!)
		imageProvider.tintColor = currentUVIndex.color
		complicationTemplate.imageProvider = imageProvider
		
		return complicationTemplate
	}
	
}

class UtilitarianLargeComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
		
		var longText: String
		var shortText: String
		
		switch OptionsHelper().complicationDisplayOption {
		case .complicationShowsHighValue:
			longText = "Now \(currentUVIndex.uvValue) High \(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.shortTimeString)"
			shortText = "Now \(currentUVIndex.uvValue) Hi \(highUVForecast.uvIndex.uvValue)"
		default:
			longText = "Now \(currentUVIndex.uvValue) \(nextHourForecast.date.shortTimeString) \(nextHourForecast.uvIndex.uvValue)"
			shortText = "Now \(currentUVIndex.uvValue) \(nextHourForecast.date.shortTimeString) \(nextHourForecast.uvIndex.uvValue)"
		}
		
		
		let textProvider = CLKSimpleTextProvider(text: longText, shortText: shortText)
		complicationTemplate.textProvider = textProvider
		
		return complicationTemplate
	}
	
}
