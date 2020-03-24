//
//  BackgroundUpdateHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/23/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import WatchKit

class BackgroundUpdateHelper {
	
	class func scheduleBackgroundUpdate(with location: Location, preferredDate: Date?) {
		
		// By default, schedule the next update for the start of the next hour
		let preferredDate = preferredDate ?? Date().startOfNextHour
		let userInfo = ["latitude" : 0.0, "longitude" : 0.0] as (NSSecureCoding & NSObjectProtocol)
		
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: preferredDate, userInfo: userInfo) { (error) in
			
			if error != nil {
				print("Couldn't schedule background update task: \(error!.localizedDescription)")
			}
			
			print("Scheduled next background update task for: \(preferredDate)")
			
		}
		
	}
	
}
