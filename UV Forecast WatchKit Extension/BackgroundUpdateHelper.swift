//
//  BackgroundUpdateHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/23/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import WatchKit

class BackgroundUpdateHelper {
	
	class func scheduleBackgroundUpdate(preferredDate: Date?) {
		
		// By default, schedule the next update for the start of the next hour
		let preferredDate = preferredDate ?? Date().startOfNextHour

		// The userInfo property isn't working in watchOS 6.2 (17T529)
		// As a workaround, I'm saving the last known location in UserDefaults (see LocationManager)
		
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: preferredDate, userInfo: nil) { (error) in
			
			if error != nil {
				print("Couldn't schedule background update task: \(error!.localizedDescription)")
			}
			
			print("Scheduled next background update task for: \(preferredDate)")
			
		}
		
	}
	
	class func didCompleteBackgroundRefreshFetch(shouldUpdateAppSnapshot: Bool) {
		
		ComplicationController().reloadComplicationTimeline()
		
		BackgroundUpdateHelper.scheduleBackgroundUpdate(preferredDate: nil)
		
		print("Background refresh fetch did complete; requsting app snapshot")
		
		let extensionDelegate = WKExtension.shared().delegate as? ExtensionDelegate
		extensionDelegate?.pendingRefreshBackgroundTask?.setTaskCompletedWithSnapshot(shouldUpdateAppSnapshot)
		extensionDelegate?.pendingRefreshBackgroundTask = nil
		
	}
	
}
