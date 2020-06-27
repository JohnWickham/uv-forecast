//
//  File.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 6/26/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct TodayGraphView: View {
	
	var day: Day
	var lineWidth: CGFloat = 4
	
	let gradientStops: [Gradient.Stop] = [
		Gradient.Stop(color: Color(UVIndex.lowColor), location: 0),
		Gradient.Stop(color: Color(UVIndex.moderateColor), location: 0.25),
		Gradient.Stop(color: Color(UVIndex.highColor), location: 0.5),
		Gradient.Stop(color: Color(UVIndex.veryHighColor), location: 0.75),
		Gradient.Stop(color: Color(UVIndex.extremeColor), location: 1.0)
	]
	
	var body: some View {
		GeometryReader { reader in
			LinearGradient(gradient: Gradient(stops: gradientStops), startPoint: .leading, endPoint: .trailing)
			.mask(
				Path { path in
					path.move(to: CGPoint(x: reader.safeAreaInsets.leading + (self.lineWidth / 2), y: reader.frame(in: .local).midY))
					path.addLine(to: CGPoint(x: reader.size.width - (self.lineWidth / 2), y: reader.frame(in: .local).midY))
				}
				.stroke(Color.black, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase:0))
			)
		}
	}
}



struct TodayGraphView_Previews: PreviewProvider {
	static var previews: some View {
		TodayGraphView(day: mockDataTodayTimeline.days.first!)
	}
}
