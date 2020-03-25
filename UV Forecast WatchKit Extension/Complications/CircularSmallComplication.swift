//
//  CircularSmallComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class CircularSmallComplicationHelper {
	
	class func timelineEntry(for date: Date, uvIndex: UVIndex) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex)
		return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
	}
	
	class func complicationTemplate(for uvIndex: UVIndex) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateCircularSmallStackImage()
		
		let image = UIImage(systemName: "sun.max.fill")!
		let imageProvider = CLKImageProvider(onePieceImage: image)
		imageProvider.tintColor = uvIndex.color
		complicationTemplate.line1ImageProvider = imageProvider
		
		let textProvider = CLKSimpleTextProvider(text: "\(uvIndex.uvValue)")
		textProvider.tintColor = uvIndex.color
		complicationTemplate.line2TextProvider = textProvider
		
		return complicationTemplate
	}
	
}
