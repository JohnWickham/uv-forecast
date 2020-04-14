//
//  ForecastRowView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

//struct SeparatorView: View {
//	var body: some View {
//		RoundedRectangle(cornerRadius: 1.0, style: .continuous)
//			.frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
//			.background(Color.white)
//			.opacity(0.1)
//	}
//}

struct UVIndexLabelView: View {
	var uvIndex: UVIndex
	
	var body: some View {
		HStack {
			Text(String(format: "%.f", uvIndex.uvValue.rounded()))
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
			.padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
			
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
		.padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
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
		.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
	}
	
}
