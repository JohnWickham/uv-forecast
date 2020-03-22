//
//  LoadingView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
	
	var body: some View {
		VStack {
			Image(systemName: "sun.max.fill")
				.foregroundColor(.orange)
				.imageScale(.large)
				.rotationEffect(.degrees(120))
				.animation(Animation.linear(duration: 3).repeatForever())//FIXME: This animation doesn't work.
			Text("Loading…")
		}
	}
	
}
