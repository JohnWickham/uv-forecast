//
//  ComplicationController.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
	
	enum ComplicationIdentifier: String {
		case currentUVIndexForecast = "Current UV Index"
		case maxUVIndexForecast = "Max UV Index"
		case upcomingUVIndexForecast = "Next Hour UV Index"
	}
	
	func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {

		let supportedFamiliesForComboComplications: [CLKComplicationFamily] = [.modularLarge, .utilitarianLarge, .graphicBezel, .graphicRectangular, .graphicExtraLarge]
		let supportedFamiliesForCurrentOnly = CLKComplicationFamily.allCases.filter { (family) -> Bool in
			!supportedFamiliesForComboComplications.contains(family)
		}
		
		let currentUVIndexForecastDescriptor = CLKComplicationDescriptor(identifier: ComplicationIdentifier.currentUVIndexForecast.rawValue, displayName: "Current UV Index", supportedFamilies: supportedFamiliesForCurrentOnly)
		let maxUVIndexForecastDescriptor = CLKComplicationDescriptor(identifier: ComplicationIdentifier.maxUVIndexForecast.rawValue, displayName: "Current & Today’s High UV Index", supportedFamilies: [.modularLarge, .utilitarianLarge, .graphicBezel, .graphicRectangular, .graphicExtraLarge])
		let upcomingUVIndexForecastDescriptor = CLKComplicationDescriptor(identifier: ComplicationIdentifier.upcomingUVIndexForecast.rawValue, displayName: "Current & Next Hour UV Index", supportedFamilies: supportedFamiliesForComboComplications)
		
		handler([currentUVIndexForecastDescriptor, maxUVIndexForecastDescriptor, upcomingUVIndexForecastDescriptor])
		
	}
	
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
		let lastForecastDate = DataStore.shared.forecastTimeline?.allHourlyTimelineEntries.last?.date
		handler(lastForecastDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
		handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		
		guard let forecastTimeline = DataStore.shared.forecastTimeline,
			let currentUVIndex = DataStore.shared.currentUVIndex,
			let currentForecast = forecastTimeline.currentUVForecast,
			let nextHourForecast = forecastTimeline.timelineEntry(after: currentForecast) as? UVForecast,
			let highForecast = DataStore.shared.todayHighForecast else {
				handler(nil)
				return
		}
		
		let helper = complicationHelper(for: complication)
		let identifier = ComplicationController.ComplicationIdentifier(rawValue: complication.identifier) ?? .maxUVIndexForecast
		handler(helper?.timelineEntry(for: Date(), currentUVIndex: currentUVIndex, nextHourForecast: nextHourForecast, highUVForecast: highForecast, complicationIdentifier: identifier))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
		
		guard let forecastTimeline = DataStore.shared.forecastTimeline,
			let currentForecast = forecastTimeline.currentUVForecast,
			let nextHourForecast = forecastTimeline.timelineEntry(after: currentForecast) as? UVForecast,
			let highUVForecast = DataStore.shared.todayHighForecast else {
			handler(nil)
			return
		}
        
		let filteredForecasts = forecastTimeline.allHourlyTimelineEntries
			.filter { (forecast) -> Bool in
			forecast.date > date
		}
		
		let entries = filteredForecasts.compactMap { (forecast) -> CLKComplicationTimelineEntry? in
			guard let forecast = forecast as? UVForecast else {
				return nil
			}
			let identifier = ComplicationController.ComplicationIdentifier(rawValue: complication.identifier) ?? .maxUVIndexForecast
			return complicationHelper(for: complication)?.timelineEntry(for: forecast.date, currentUVIndex: forecast.uvIndex, nextHourForecast: nextHourForecast, highUVForecast: highUVForecast, complicationIdentifier: identifier)
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
		let sampleHighForecast = UVForecast(date: sampleHighDate, uvIndex: UVIndex(uvValue: 10), temperature: 72.0)
		let sampleNextHourDate = formatter.date(from: "2:00 PM")!
		let sampleNextHourForecast = UVForecast(date: sampleNextHourDate, uvIndex: UVIndex(uvValue: 9.0), temperature: 81.0)
		
		let helper = complicationHelper(for: complication)
		let identifier = ComplicationController.ComplicationIdentifier(rawValue: complication.identifier) ?? .maxUVIndexForecast
		handler(helper?.complicationTemplate(for: sampleUVIndex, nextHourForecast: sampleNextHourForecast, highUVForecast: sampleHighForecast, complicationIdentifier: identifier))
    }
    
}
