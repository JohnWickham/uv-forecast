//
//  UtilitarianSmall.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class UtilitarianSmallComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast, complicationIdentifier: ComplicationController.ComplicationIdentifier) -> CLKComplicationTemplate {
		
		let textProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
		textProvider.tintColor = currentUVIndex.color
		
		let imageProvider = CLKImageProvider(onePieceImage: UIImage(systemName: "sun.max.fill")!)
		imageProvider.tintColor = currentUVIndex.color
		
		return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider, imageProvider: imageProvider)
	}
	
}

class UtilitarianLargeComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast, complicationIdentifier: ComplicationController.ComplicationIdentifier) -> CLKComplicationTemplate {
		
		var longText: String
		var shortText: String
		
		switch complicationIdentifier {
		case .maxUVIndexForecast:
			longText = "Now \(currentUVIndex.uvValue) High \(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.hourTimeString)"
			shortText = "Now \(currentUVIndex.uvValue) Hi \(highUVForecast.uvIndex.uvValue)"
		default:
			longText = "Now \(currentUVIndex.uvValue) \(nextHourForecast.date.hourTimeString) \(nextHourForecast.uvIndex.uvValue)"
			shortText = "Now \(currentUVIndex.uvValue) \(nextHourForecast.date.hourTimeString) \(nextHourForecast.uvIndex.uvValue)"
		}
		
		let textProvider = CLKSimpleTextProvider(text: longText, shortText: shortText)
		
		return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider)
	}
	
}
