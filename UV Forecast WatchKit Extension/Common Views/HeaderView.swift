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
	var uvIndex: UVIndex
	
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

			HStack(alignment: .firstTextBaseline, spacing: 5, content: {
				Text(formattedValueString)
					.font(.system(size: 45, weight: .medium, design: .default))
					.foregroundColor(Color(uvIndex.color))
				Text(uvIndex.description)
					.fontWeight(.medium)
					.foregroundColor(Color(uvIndex.color))
			})
		})
		.padding(EdgeInsets(top: 5, leading: 8, bottom: 0, trailing: 8))

	}
	
	var formattedValueString: String {
		let value = uvIndex.uvValue
		return String(format: (value > 9 ? "%.f" : "%.1f"), value)
	}
}
