//
//  HeaderView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
	
	var title: String
	var detail: String?
	var forecastEntry: ForecastTimelineEntry
	
	var body: some View {
		
		VStack(alignment: .leading, spacing: -5, content: {
			
			HStack(alignment: .firstTextBaseline, spacing: 0) {
				Text(title.uppercased())
					.font(.system(.caption))
				Spacer()
				Text(detail ?? "")
					.font(.system(.caption))
					.foregroundColor(.secondary)
			}
			
			switch forecastEntry {
			case is Night:
				Spacer()
					.frame(height: 10)
				HStack(alignment: .firstTextBaseline, spacing: 5, content: {
					Image(systemName: "moon.stars.fill")
						.font(.system(size: 20))
						.foregroundColor(.purple)
					Text(["Night–night.", "Good night.", "Sweet dreams.", "See you tomorrow.", "Sleep tight."].randomElement()!)
						.fontWeight(.medium)
						.foregroundColor(.purple)
				})
			case let uvForecast as UVForecast:
				HStack(alignment: .firstTextBaseline, spacing: 5, content: {
					Text(formattedValueString)
						.font(.system(size: 45, weight: .medium, design: .default))
						.foregroundColor(Color(uvForecast.uvIndex.color))
					Text(uvForecast.uvIndex.description)
						.fontWeight(.medium)
						.foregroundColor(Color(uvForecast.uvIndex.color))
				})
			default:
				fatalError()
			}
			
		})
		.padding(EdgeInsets(top: 5, leading: 8, bottom: 0, trailing: 8))

	}
	
	var formattedValueString: String {
		let value = (forecastEntry as! UVForecast).uvIndex.uvValue
		return String(format: (value > 9 ? "%.f" : "%.1f"), value)
	}
}

struct HeaderView_Previews: PreviewProvider {	
	static var previews: some View {
		HeaderView(title: "Now", detail: "San Francisco", forecastEntry: UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 7.0), temperature: 72))
		
		HeaderView(title: "Now", detail: "San Francisco", forecastEntry: Night(date: Date(), endDate: Date()))
	}
}
