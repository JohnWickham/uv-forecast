//
//  Data.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation
import SwiftUI

enum ForecastTimelineEntry: Comparable {
	case uvForecast(_: UVForecast)
	case sunEvent(_: SunEvent)
	
	static func < (lhs: ForecastTimelineEntry, rhs: ForecastTimelineEntry) -> Bool {
		
		switch (lhs, rhs) {
		case (.uvForecast(let lhsForecast), .uvForecast(let rhsForecast)):
			return lhsForecast.date < rhsForecast.date
		case (.uvForecast(let lhsForecast), .sunEvent(let rhsSunEvent)):
			return lhsForecast.date < rhsSunEvent.date
		case (.sunEvent(let lhsSunEvent), .sunEvent(let rhsSunEvent)):
			return lhsSunEvent.date < rhsSunEvent.date
		case (.sunEvent(let lhsSunEvent), .uvForecast(let rhsForecast)):
			return lhsSunEvent.date < rhsForecast.date
		}
		
	}
	
}

struct SunEvent: Comparable {
	
	enum SunEventType {
		case sunrise, sunset
	}
	
	var date: Date
	
	var eventType: SunEventType
	
	static func < (lhs: SunEvent, rhs: SunEvent) -> Bool {
		lhs.date < rhs.date
	}
	
}

struct UVForecast: Comparable {
	
	/// The day that the forecast is for
	var date: Date
	
	/// The UV index at the given `date`
	var uvIndex: UVIndex
	
	static func < (lhs: UVForecast, rhs: UVForecast) -> Bool {
		return lhs.uvIndex < rhs.uvIndex
	}
}

struct UVIndex: Comparable {
	
	var uvValue: Double
	
	var description: String {
		switch uvValue {
		case _ where uvValue < 2.99:
			return "Low"
		case 3.0 ... 5.99:
			return "Moderate"
		case 6.0 ... 7.99:
			return "High"
		case 8.0 ... 10.99:
			return "Very High"
		default:
			return "Extreme"
		}
	}
	
	var shortDescription: String {
		switch uvValue {
		case _ where uvValue < 2.99:
			return "Low"
		case 3.0 ... 5.99:
			return "Mod"
		case 6.0 ... 7.99:
			return "Hi"
		case 8.0 ... 10.99:
			return "V Hi"
		default:
			return "X"
		}
	}
	
	static let lowColor = UIColor(red:0.016, green:0.871, blue:0.443, alpha:1.00)
	static let moderateColor = UIColor(red:1.000, green:0.804, blue:0.086, alpha:1.00)
	static let highColor = UIColor(red:1.000, green:0.584, blue:0.000, alpha:1.00)
	static let veryHighColor = UIColor(red:1.000, green:0.231, blue:0.188, alpha:1.00)
	static let extremeColor = UIColor(red:0.667, green:0.000, blue:0.996, alpha:1.00)
	
	var color: UIColor {
		switch uvValue {
		case _ where uvValue < 2.99:
			return UVIndex.lowColor
		case 3.0 ... 5.99:
			return UVIndex.moderateColor
		case 6.0 ... 7.99:
			return UVIndex.highColor
		case 8.0 ... 10.99:
			return UVIndex.veryHighColor
		default:
			return UVIndex.extremeColor
		}
	}
	
	static func < (lhs: UVIndex, rhs: UVIndex) -> Bool {
		lhs.uvValue < rhs.uvValue
	}
	
}

