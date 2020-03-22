//
//  LoadingView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
	
	@State var iconRotationAngle: Float = 0
	
	var body: some View {
		VStack {
			Image(systemName: "sun.max.fill")
				.foregroundColor(.orange)
				.font(.system(size: 25))
				.rotationEffect(.degrees(Double(iconRotationAngle)))
				.animation(Animation.linear(duration: 4.0).repeatForever(autoreverses: false))
			Text("Loading…")
		}.onAppear {
			self.iconRotationAngle = 360
		}
	}
	
}
