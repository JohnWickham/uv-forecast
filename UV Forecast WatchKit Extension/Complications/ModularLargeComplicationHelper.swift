//
//  ModularLargeComplicationHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class ModularLargeComplicationHelper {
	
	class func timelineEntry(for currentUVIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: currentUVIndex, highUVForecast: highUVForecast)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for currentUVIndex: UVIndex, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
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
		
		let highForecastLabelTextProvider = CLKSimpleTextProvider(text: "High")
		highForecastLabelTextProvider.tintColor = .white
		complicationTemplate.row2Column1TextProvider = highForecastLabelTextProvider
		
		let highForecastValueTextProvider = CLKSimpleTextProvider(text: "\(highUVForecast.uvIndex.uvValue) at \(highUVForecast.date.shortTimeString)")
		highForecastValueTextProvider.tintColor = .white
		complicationTemplate.row2Column2TextProvider = highForecastValueTextProvider
		
		return complicationTemplate
		
	}
	
}
