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

	var gradientStops: [Gradient.Stop] {
		return day.remainingDaytimeForecasts.enumerated().compactMap { (index, forecast) -> Gradient.Stop? in

			guard let forecast = forecast as? UVForecast else {
				return nil
			}

			return Gradient.Stop(color: Color(forecast.uvIndex.color), location: CGFloat(Double(index) * 0.1))

		}
	}

	func drawGraphLinePath(in geometryReader: GeometryProxy) -> some View {
		Path { path in
			
			let daytimeUVForecasts = day.remainingDaytimeForecasts.compactMap { (entry) -> UVForecast? in
				if let forecast = entry as? UVForecast {
					return forecast
				}
				return nil
			}
			
			let forecasts = daytimeUVForecasts.enumerated().compactMap { (index, forecast) -> UVForecast? in
				
				if index == 0 || index == daytimeUVForecasts.count - 1 || forecast == daytimeUVForecasts.max() {
					return forecast
				}
				
				return nil
				
			}
			
			let maximumForecast = forecasts.max()!
			let indexOfHighForecast = daytimeUVForecasts.firstIndex(of: maximumForecast) ?? (daytimeUVForecasts.count / 2)
			let highForecastFraction = CGFloat(Float(indexOfHighForecast) / Float(daytimeUVForecasts.count))

			let graphSafeAreaWidth = geometryReader.frame(in: .local).size.width - (geometryReader.safeAreaInsets.leading + geometryReader.safeAreaInsets.trailing)
			let graphSafeAreaHeight = geometryReader.frame(in: .local).size.height - (geometryReader.safeAreaInsets.top + geometryReader.safeAreaInsets.bottom)
			let graphFrame = geometryReader.frame(in: .local)
			
			/// TODO: The curve factor should really be a function of the distance between the two points being curved
			let curveFactor: CGFloat = 10
			
			func calculateCurveFactor(between point1: CGPoint, and point2: CGPoint) -> CGFloat {
				let factor = point2.x - point1.x
				return graphSafeAreaWidth / factor
			}

			let startX = 0 + (lineWidth / 2)
			let startY = graphSafeAreaHeight - (lineWidth / 2)
			let startPoint = CGPoint(x: startX, y: startY)
			path.move(to: startPoint)
			
			let maxX = graphSafeAreaWidth * highForecastFraction
			let maxY = graphSafeAreaHeight - (graphFrame.height / CGFloat(maximumForecast.uvIndex.uvValue))
			let point2 = CGPoint(x: maxX, y: maxY)
			path.addCurve(to: point2, control1: CGPoint(x: graphSafeAreaWidth / curveFactor, y: startY), control2: CGPoint(x: maxX - (graphSafeAreaWidth / 5), y: maxY))
			
			let endX = graphFrame.maxX - (lineWidth / 2)
			let endY = graphSafeAreaHeight
			let point3 = CGPoint(x: endX, y: endY)
			path.addCurve(to: point3, control1: CGPoint(x: maxX + (graphSafeAreaWidth / 5), y: maxY), control2: CGPoint(x: endX - (graphSafeAreaWidth / curveFactor), y: endY))
			
		}
		.stroke(Color.black, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase:0))
	}

	var body: some View {
		GeometryReader { reader in
			ZStack {
				LinearGradient(gradient: Gradient(stops: gradientStops), startPoint: .leading, endPoint: .trailing)
					.mask(drawGraphLinePath(in: reader))
			}
		}
	}
}

struct TodayGraphView_Previews: PreviewProvider {
	static var previews: some View {
		TodayGraphView(day: mockDataTodayTimeline.days.first!)
			.border(Color.white.opacity(0.2), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
	}
}
