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
	var uvIndex: UVIndex
	
	var body: some View {
		VStack(alignment: .leading, spacing: -5, content: {
			Text(title.uppercased()).font(.system(.caption))
			HStack(alignment: .firstTextBaseline, spacing: 5, content: {
				Text(String(format: "%.1f", uvIndex.value)).font(.system(size: 45, weight: .medium, design: .default)).foregroundColor(uvIndex.color)
				Text(uvIndex.description).fontWeight(.medium).foregroundColor(uvIndex.color)
			})
		})
		.padding(EdgeInsets(top: 5, leading: 8, bottom: 0, trailing: 8))

	}
}
