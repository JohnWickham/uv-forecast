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
		let lastForecastDate = DataStore.shared.hourlyForecasts.last?.date
		handler(lastForecastDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
		handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		
		let currentForecast = DataStore.shared.currentUVIndex
		let highForecast = DataStore.shared.todayHighForecast
		var entry: CLKComplicationTimelineEntry? = nil
		
		switch complication.family {
		case .graphicCircular:
			entry = OpenGaugeComplicationHelper.timelineEntry(for: currentForecast)
		case .circularSmall:
			entry = CircularSmallComplicationHelper.timelineEntry(for: currentForecast)
		case .modularSmall:
			entry = ModularSmallComplicationHelper.timelineEntry(for: currentForecast)
		case .utilitarianSmall, .utilitarianSmallFlat:
			entry = UtilitarianSmallComplicationHelper.timelineEntry(for: currentForecast)
		case .utilitarianLarge:
			entry = UtilitarianLargeComplicationHelper.timelineEntry(for: currentForecast, highUVForecast: highForecast)
		case .graphicCorner:
			entry = GaugeComplicationHelper.timelineEntry(for: currentForecast)
		default:
			entry = nil
		}
		
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        
		let filteredForecasts = DataStore.shared.hourlyForecasts.filter { (forecast) -> Bool in
			forecast.date > date
		}
		
		let entries = filteredForecasts.compactMap { (forecast) -> CLKComplicationTimelineEntry? in
			
			switch complication.family {
			case .graphicCircular:
				return OpenGaugeComplicationHelper.timelineEntry(for: forecast.uvIndex)
			case .circularSmall:
				return CircularSmallComplicationHelper.timelineEntry(for: forecast.uvIndex)
			case .modularSmall:
				return ModularSmallComplicationHelper.timelineEntry(for: forecast.uvIndex)
			case .utilitarianSmall, .utilitarianSmallFlat:
				return UtilitarianSmallComplicationHelper.timelineEntry(for: forecast.uvIndex)
			case .utilitarianLarge:
				return UtilitarianLargeComplicationHelper.timelineEntry(for: forecast.uvIndex, highUVForecast: DataStore.shared.todayHighForecast)
			case .graphicCorner:
				return GaugeComplicationHelper.timelineEntry(for: forecast.uvIndex)
			default:
				return nil
			}
			
		}
		
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		
		var template: CLKComplicationTemplate? = nil
		let sampleUVIndex = UVIndex(value: 7.0)
		
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		let sampleHighDate = formatter.date(from: "1:00 PM")!
		let sampleHighForecast = Forecast(date: Date(), highIndexDate: sampleHighDate, uvIndex: UVIndex(value: 10))
		
		switch complication.family {
		case .graphicCircular:
			template = OpenGaugeComplicationHelper.complicationTemplate(for: sampleUVIndex)
		case .circularSmall:
			template = CircularSmallComplicationHelper.complicationTemplate(for: sampleUVIndex)
		case .modularSmall:
			template = ModularSmallComplicationHelper.complicationTemplate(for: sampleUVIndex)
		case .utilitarianSmall, .utilitarianSmallFlat:
			template = UtilitarianSmallComplicationHelper.complicationTemplate(for: sampleUVIndex)
		case .utilitarianLarge:
			template = UtilitarianLargeComplicationHelper.complicationTemplate(for: sampleUVIndex, highUVForecast: sampleHighForecast)
		case .graphicCorner:
			template = GaugeComplicationHelper.complicationTemplate(for: sampleUVIndex)
		default:
			template = nil
		}
		
		handler(template)
    }
    
}
