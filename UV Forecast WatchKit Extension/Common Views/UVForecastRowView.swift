//
//  ForecastRowView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct SeparatorView: View {
	var body: some View {
		RoundedRectangle(cornerRadius: 1.0, style: .continuous)
			.frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
			.background(Color.white)
			.opacity(0.1)
	}
}

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

struct TimelineRowView: View {
	
	var timelineEntry: ForecastTimelineEntry
	var title: String
	var detail: String
	
	var body: some View {
		VStack {
			HStack(alignment: .firstTextBaseline, spacing: 0) {
				textGroup
				Spacer()
				detailView
			}
			.padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
			
			SeparatorView()
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
	
	var detailView: some View {
		if let uvForecast = timelineEntry as? UVForecast {
			return AnyView(UVIndexLabelView(uvIndex: uvForecast.uvIndex))
		}
		else if let sunEvent = timelineEntry as? SunEvent {
			return AnyView(Image((sunEvent.eventType == .sunrise) ? "Sunrise" : "Sunset").foregroundColor(.orange))
		}
		return AnyView(Text(""))
	}
}

struct UVForecastRowView_Previews: PreviewProvider {
	static var previews: some View {
		List {
			ForEach(0..<10) { (index) -> TimelineRowView in
				TimelineRowView(timelineEntry: SunEvent(date: Date(), eventType: .sunset), title: "1 PM", detail: "")
			}
		}
	}
}
