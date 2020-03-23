//
//  Data.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation
import SwiftUI

//enum SunEvent {
//	case sunrise(_ date: Date)
//	case sunset(_ date: Date)
//}
//
//enum ForecastTimelineEntry {
//	case uvIndex(_: UVIndex)
//	case sunEvent(_: SunEvent)
//}

struct Forecast: Comparable {
	
	/// The day that the forecast is for
	var date: Date
	
	/// The UV index at the given `date`
	var uvIndex: UVIndex
	
	static func < (lhs: Forecast, rhs: Forecast) -> Bool {
		return lhs.uvIndex < rhs.uvIndex
	}
}

struct UVIndex: Comparable {
	
	var value: Double = 0.0
	
	var description: String {
		switch value {
		case _ where value < 2.99:
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
		switch value {
		case _ where value < 2.99:
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
		switch value {
		case _ where value < 2.99:
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
		lhs.value < rhs.value
	}
	
}
