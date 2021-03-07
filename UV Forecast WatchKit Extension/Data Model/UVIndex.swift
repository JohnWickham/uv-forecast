//
//  Data.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation
import SwiftUI

class UVForecast: ForecastTimelineEntry {
	
	/// The UV index at the given `date`
	var uvIndex: UVIndex
	
	/// The temperature in farenheit
	var temperature: Double?
	
	var formattedTemperatureString: String? {
		guard let temperature = self.temperature else {
			return nil
		}
		
		let rounded = Int(temperature.rounded())
		return "\(rounded)º"
	}
	
	init(date: Date, uvIndex: UVIndex, temperature: Double?) {
		self.uvIndex = uvIndex
		self.temperature = temperature
		super.init(date: date)
	}
	
}

class Night: ForecastTimelineEntry {
	
	var endDate: Date
	
	init(date: Date, endDate: Date) {
		self.endDate = endDate
		super.init(date: date)
	}
	
}

struct UVIndex: Comparable {
	
	var uvValue: Double
	
	/// E.g. "Low" or "Extreme"
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
	
	/// E.g. "Low", "Hi", or "X"
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

