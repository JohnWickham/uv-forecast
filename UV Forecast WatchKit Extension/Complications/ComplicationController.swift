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
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		
		let currentForecast = DataStore.shared.currentUVIndex
		var entry: CLKComplicationTimelineEntry? = nil
		
		switch complication.family {
		case .graphicCircular:
			entry = OpenGaugeComplicationHelper.timelineEntry(for: currentForecast)
		case .circularSmall:
			entry = CircularSmallComplicationHelper.timelineEntry(for: currentForecast)
		default:
			entry = GaugeComplicationHelper.timelineEntry(for: currentForecast)
		}
		
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
			
			switch complication.family {
			case .graphicCircular:
				return OpenGaugeComplicationHelper.timelineEntry(for: forecast.uvIndex)
			case .circularSmall:
				return CircularSmallComplicationHelper.timelineEntry(for: forecast.uvIndex)
			default:
				return GaugeComplicationHelper.timelineEntry(for: forecast.uvIndex)
			}
			
		}
		
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		
		var template: CLKComplicationTemplate? = nil
		let sampleUVIndex = UVIndex(value: 7.0)
		
		switch complication.family {
		case .graphicCircular:
			template = OpenGaugeComplicationHelper.complicationTemplate(for: sampleUVIndex)
		case .circularSmall:
			template = CircularSmallComplicationHelper.complicationTemplate(for: sampleUVIndex)
		default:
			template = GaugeComplicationHelper.complicationTemplate(for: sampleUVIndex)
		}
		
		handler(template)
    }
    
}
