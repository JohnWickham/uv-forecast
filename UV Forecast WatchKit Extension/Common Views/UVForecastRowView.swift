//
//  ForecastRowView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct UVIndexLabelView: View {
	var uvIndex: UVIndex
	
	var body: some View {
		HStack {
			Text(String(format: "%.f", uvIndex.uvValue))
				.fontWeight(.semibold)
				.foregroundColor(Color(uvIndex.color))
		}
		.padding(EdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7))
		.background(Color(uvIndex.color)
		.opacity(0.15))
		.cornerRadius(5, antialiased: true)
	}
	
}

struct UVForecastTimelineRowView: View {
	
	var title: String
	var detail: String
	var forecast: UVForecast
	
	var body: some View {
		VStack {
			HStack(alignment: .firstTextBaseline, spacing: 0) {
				textGroup
				Spacer()
				UVIndexLabelView(uvIndex: forecast.uvIndex)
			}
			.padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
			
			Divider()
		}
	}
	
	var textGroup: some View {
		HStack(alignment: .firstTextBaseline, spacing: 0) {
			Text(title)
				.font(.system(.body))
			Spacer()
			Text(detail)
				.font(.system(.body))
		}
		.frame(maxWidth: 100)
	}

}

struct NightTimelineRowView: View {
	
	var night: Night
	var sunsetDate: Date
	var sunriseDate: Date
	
	var body: some View {
		VStack {
			sunsetGroup
			sunriseGroup
			Divider()
		}
	}
	
	var sunsetGroup: some View {
		HStack(alignment: .center, spacing: 0) {
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text(sunsetDate.timeString)
				Text(sunsetDate.shortWeekDayString.uppercased()).foregroundColor(.secondary)
			}
			Spacer()
			Image("Sunset")
		}
		.padding(EdgeInsets(top: 8, leading: 8, bottom: 5, trailing: 8))
	}
	
	var sunriseGroup: some View {
		HStack(alignment: .center, spacing: 0) {
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text(sunriseDate.timeString)
				Text(sunriseDate.shortWeekDayString.uppercased()).foregroundColor(.secondary)
			}
			Spacer()
			Image("Sunrise")
		}
		.padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
	}
	
}

struct UVForecastRowView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			VStack {
				UVForecastTimelineRowView(title: "10 AM", detail: "", forecast: UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 7), temperature: nil))
				UVForecastTimelineRowView(title: "11 AM", detail: "", forecast: UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 9), temperature: nil))
				UVForecastTimelineRowView(title: "1 PM", detail: "", forecast: UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 12), temperature: nil))
				NightTimelineRowView(night: Night(date: Date(), endDate: Date() + 86400), sunsetDate: Date(), sunriseDate: Date())
			}
			
			VStack {
				UVForecastTimelineRowView(title: "Today", detail: "1 PM", forecast: UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 10), temperature: nil))
				UVForecastTimelineRowView(title: "SAT", detail: "12 PM", forecast: UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 8), temperature: nil))
				UVForecastTimelineRowView(title: "SUN", detail: "1 PM", forecast: UVForecast(date: Date(), uvIndex: UVIndex(uvValue: 11), temperature: nil))
			}
			.environment(\.sizeCategory, .small)
		}
	}
}
