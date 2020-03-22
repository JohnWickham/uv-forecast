//
//  ErrorView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
	
	var error: Error
	
	var retryAction: (() -> Void)
	
	var errorImage: some View {
		switch self.error {
		case LocationError.permissionDenied:
			return Image(systemName: "location.slash.fill").foregroundColor(.red).font(.system(size: 30))
		default:
			return Image(systemName: "cloud.sun.fill").foregroundColor(.gray).font(.system(size: 30))
		}
	}
	
	var body: some View {
		VStack(alignment: .center, spacing: 10) {
			errorImage
			Text(error.localizedDescription).multilineTextAlignment(.center)
			Button(action: retryAction, label: {
				Text("Try Again")
			})
		}
	}
	
	
}
