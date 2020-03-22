//
//  HostingController.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class TodayHostingController: WKHostingController<TodayView> {
    override var body: TodayView {
        self.setTitle("Today")
		return TodayView(dataStore: DataStore.shared)
    }
}

class ForecastHostingController: WKHostingController<ForecastView> {
    override var body: ForecastView {
        self.setTitle("Forecast")
		return ForecastView(dataStore: DataStore.shared)
    }
}
