//
//  ModularLargeComplicationHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class ModularLargeComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let headerImage = UIImage(systemName: "sun.max.fill")!
		let headerImageProvider = CLKImageProvider(onePieceImage: headerImage)
		headerImageProvider.tintColor = currentUVIndex.color
		
		let headerTextProvider = CLKSimpleTextProvider(text: "UV Forecast")
		headerTextProvider.tintColor = currentUVIndex.color
		
		let currentLabelTextProvider = CLKSimpleTextProvider(text: "Now")
		currentLabelTextProvider.tintColor = .white
		
		let currentValueTextProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue) \(currentUVIndex.description)")
		currentValueTextProvider.tintColor = .white
		
		var row2Column1TextProvider: CLKSimpleTextProvider
		var row2Column2TextProvider: CLKSimpleTextProvider
		
		switch OptionsHelper().complicationDisplayOption {
		case .complicationShowsHighValue:
			row2Column1TextProvider = CLKSimpleTextProvider(text: "High")
			row2Column1TextProvider.tintColor = .white
			row2Column2TextProvider = CLKSimpleTextProvider(text: "\(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.hourTimeString)")
			row2Column2TextProvider.tintColor = .white
		default:
			row2Column1TextProvider = CLKSimpleTextProvider(text: nextHourForecast.date.hourTimeString)
			row2Column1TextProvider.tintColor = .white
			row2Column2TextProvider = CLKSimpleTextProvider(text: "\(nextHourForecast.uvIndex.uvValue) \(nextHourForecast.uvIndex.description)")
			row2Column2TextProvider.tintColor = .white
		}
		
		return CLKComplicationTemplateModularLargeTable(headerImageProvider: headerImageProvider, headerTextProvider: headerTextProvider, row1Column1TextProvider: currentLabelTextProvider, row1Column2TextProvider: currentValueTextProvider, row2Column1TextProvider: row2Column1TextProvider, row2Column2TextProvider: row2Column2TextProvider)
		
	}
	
}
