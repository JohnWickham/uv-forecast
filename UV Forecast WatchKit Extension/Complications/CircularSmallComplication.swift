//
//  CircularSmallComplication.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/22/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class CircularSmallComplicationHelper: ComplicationHelper {
	
	func complicationTemplate(for currentUVIndex: UVIndex, nextHourForecast: UVForecast, highUVForecast: UVForecast) -> CLKComplicationTemplate {
		
		let image = UIImage(systemName: "sun.max.fill")!
		let imageProvider = CLKImageProvider(onePieceImage: image)
		imageProvider.tintColor = currentUVIndex.color
		
		let textProvider = CLKSimpleTextProvider(text: "\(currentUVIndex.uvValue)")
		textProvider.tintColor = currentUVIndex.color
		
		return CLKComplicationTemplateCircularSmallStackImage(line1ImageProvider: imageProvider, line2TextProvider: textProvider)
	}
	
}
