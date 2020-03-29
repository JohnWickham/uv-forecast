//
//  ComplicationController.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
	
	func reloadComplicationTimeline() {
		let complicationServer = CLKComplicationServer.sharedInstance()
		complicationServer.activeComplications?.forEach(complicationServer.reloadTimeline)
	}
	
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
		let lastForecastDate = DataStore.shared.forecastTimeline.hourlyTimelineEntries.last?.date
		handler(lastForecastDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
		handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		
		let currentUVIndex = DataStore.shared.currentUVIndex
		let highForecast = DataStore.shared.todayHighForecast
		let helper = complicationHelper(for: complication)
		handler(helper?.timelineEntry(for: Date(), currentUVIndex: currentUVIndex, highUVForecast: highForecast))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        
		let filteredForecasts = DataStore.shared.forecastTimeline.hourlyTimelineEntries
			.filter { (forecast) -> Bool in
			forecast.date > date
		}
		
		let highUVForecast = DataStore.shared.todayHighForecast
		
		let entries = filteredForecasts.compactMap { (forecast) -> CLKComplicationTimelineEntry? in
			guard let forecast = forecast as? UVForecast else {
				return nil
			}
			return complicationHelper(for: complication)?.timelineEntry(for: forecast.date, currentUVIndex: forecast.uvIndex, highUVForecast: highUVForecast)
		}
		
        handler(entries)
    }
	
	func complicationHelper(for complication: CLKComplication) -> ComplicationHelper? {
		
		var complicationHelper: ComplicationHelper? = nil
		
		switch complication.family {
		case .graphicCircular:
			complicationHelper = OpenGaugeComplicationHelper()
		case .circularSmall:
			complicationHelper = CircularSmallComplicationHelper()
		case .modularSmall:
			complicationHelper =  ModularSmallComplicationHelper()
		case .modularLarge:
			complicationHelper =  ModularLargeComplicationHelper()
		case .utilitarianSmall, .utilitarianSmallFlat:
			complicationHelper =  UtilitarianSmallComplicationHelper()
		case .utilitarianLarge:
			complicationHelper =  UtilitarianLargeComplicationHelper()
		case .graphicCorner:
			complicationHelper =  GaugeComplicationHelper()
		case .graphicRectangular:
			complicationHelper =  GraphicRectangularComplicationHelper()
		case .graphicBezel:
			complicationHelper =  GraphicBezelComplicationHelper()
		case .extraLarge:
			complicationHelper =  ExtraLargeComplicationHelper()
		default:
			return nil
		}
		
		return complicationHelper
		
	}
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		
		let sampleUVIndex = UVIndex(uvValue: 7.0)
		
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		let sampleHighDate = formatter.date(from: "1:00 PM")!
		let sampleHighForecast = UVForecast(date: sampleHighDate, uvIndex: UVIndex(uvValue: 10))
		
		let helper = complicationHelper(for: complication)
		handler(helper?.complicationTemplate(for: sampleUVIndex, highUVForecast: sampleHighForecast))
    }
    
}
