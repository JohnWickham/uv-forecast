//
//  Data.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation
import SwiftUI

struct Forecast: Comparable {
	
	/// The day that the forecast is for
	var date: Date
	
	/// The time that the UV index will be highest
	var highIndexDate: Date?
	
	/// The UV index at the given `date`
	var uvIndex: UVIndex
	
	static func < (lhs: Forecast, rhs: Forecast) -> Bool {
		return lhs.uvIndex < rhs.uvIndex
	}
}

struct ForecastList {
	var forecasts: [Forecast]
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
	
	var color: Color {
		switch value {
		case _ where value < 2.99:
			return .green
		case 3.0 ... 5.99:
			return .yellow
		case 6.0 ... 7.99:
			return .orange
		case 8.0 ... 10.99:
			return .red
		default:
			return .purple
		}
	}
	
	static func < (lhs: UVIndex, rhs: UVIndex) -> Bool {
		lhs.value < rhs.value
	}
	
}
