//
//  ComplicationController.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		let lastForecastDate = DataStore.shared.hourlyForecast.forecasts.last?.date
		handler(lastForecastDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
		handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
	
	func complicationTemplate(for uvIndex: UVIndex) -> CLKComplicationTemplate {
		
		let complicationTemplate = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
		
		let gaugeColors = [
			UVIndex.lowColor,// Green (start)
			UVIndex.moderateColor,// Yellow
			UVIndex.highColor,// Orange
			UVIndex.veryHighColor,// Red
			UVIndex.extremeColor// Purple (stop)
		]
		let gaugeColorLocations: [NSNumber] = [0.0, 0.2, 0.4, 0.6, 1.0]
		let gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: gaugeColors, gaugeColorLocations: gaugeColorLocations, fillFraction: Float(uvIndex.value / 13.0))// Using 13 as the max here even though there technically isn't a max.
		complicationTemplate.gaugeProvider = gaugeProvider
		
		complicationTemplate.centerTextProvider = CLKSimpleTextProvider(text: "\(uvIndex.value)")
		complicationTemplate.bottomTextProvider = CLKSimpleTextProvider(text: "UV")
		
		return complicationTemplate
	}
	
	func timelineEntry(for uvIndex: UVIndex) -> CLKComplicationTimelineEntry {
		let template = complicationTemplate(for: uvIndex)
		return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
	}
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		let currentForecast = DataStore.shared.currentUVIndex
		let entry = timelineEntry(for: currentForecast)
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        
		let filteredForecasts = DataStore.shared.hourlyForecast.forecasts.filter { (forecast) -> Bool in
			forecast.date > date
		}
		
		let entries = filteredForecasts.map { (forecast) -> CLKComplicationTimelineEntry in
			return timelineEntry(for: forecast.uvIndex)
		}
		
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		
		let sampleUVIndex = UVIndex(value: 7.0)
		let template = complicationTemplate(for: sampleUVIndex)
		
		handler(template)
    }
    
}
