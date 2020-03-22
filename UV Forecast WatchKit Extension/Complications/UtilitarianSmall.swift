//
//  UtilitarianSmall.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class UtilitarianSmallComplicationHelper {
	
	class func timelineEntry(for uvIndex: UVIndex) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
		
		let textProvider = CLKSimpleTextProvider(text: "\(uvIndex.value)")
		textProvider.tintColor = uvIndex.color
		complicationTemplate.textProvider = textProvider
		
		let imageProvider = CLKImageProvider(onePieceImage: UIImage(systemName: "sun.max.fill")!)
		imageProvider.tintColor = uvIndex.color
		complicationTemplate.imageProvider = imageProvider
		
		return complicationTemplate
	}
	
}

class UtilitarianLargeComplicationHelper {
	
	class func timelineEntry(for currentUVIndex: UVIndex, highUVForecast: Forecast) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: currentUVIndex, highUVForecast: highUVForecast)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
	
	class func complicationTemplate(for currentUVIndex: UVIndex, highUVForecast: Forecast) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
		
		let textProvider = CLKSimpleTextProvider(text: "Now \(currentUVIndex.value) High \(highUVForecast.uvIndex.value) at \(highUVForecast.highIndexDate!.shortTimeString)")
		complicationTemplate.textProvider = textProvider
		
		return complicationTemplate
	}
	
}
