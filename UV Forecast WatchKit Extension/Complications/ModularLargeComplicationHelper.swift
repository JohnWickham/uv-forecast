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
		
		let complicationTemplate = CLKComplicationTemplateModularLargeTable()
		
		let headerImage = UIImage(systemName: "sun.max.fill")!
		let headerImageProvider = CLKImageProvider(onePieceImage: headerImage)
		headerImageProvider.tintColor = currentUVIndex.color
		complicationTemplate.headerImageProvider = headerImageProvider
		
		let headerTextProvider = CLKSimpleTextProvider(text: "UV Forecast")
		headerTextProvider.tintColor = currentUVIndex.color
		complicationTemplate.headerTextProvider = headerTextProvider
		
		let currentLabelTextProvider = CLKSimpleTextProvider(text: "Now")
		currentLabelTextProvider.tintColor = .white
		complicationTemplate.row1Column1TextProvider = currentLabelTextProvider
		
		let currentValueTextProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue) \(currentUVIndex.description)")
		currentValueTextProvider.tintColor = .white
		complicationTemplate.row1Column2TextProvider = currentValueTextProvider
		
		var row2Column1TextProvider: CLKSimpleTextProvider
		var row2Column2TextProvider: CLKSimpleTextProvider
		
		switch OptionsHelper().complicationDisplayOption {
		case .complicationShowsHighValue:
			row2Column1TextProvider = CLKSimpleTextProvider(text: "High")
			row2Column1TextProvider.tintColor = .white
			row2Column2TextProvider = CLKSimpleTextProvider(text: "\(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.shortTimeString)")
			row2Column2TextProvider.tintColor = .white
		default:
			row2Column1TextProvider = CLKSimpleTextProvider(text: nextHourForecast.date.shortTimeString)
			row2Column1TextProvider.tintColor = .white
			row2Column2TextProvider = CLKSimpleTextProvider(text: "\(nextHourForecast.uvIndex.uvValue)")
			row2Column2TextProvider.tintColor = .white
		}
		
		complicationTemplate.row2Column1TextProvider = row2Column1TextProvider
		complicationTemplate.row2Column2TextProvider = row2Column2TextProvider
		
		return complicationTemplate
		
	}
	
}
