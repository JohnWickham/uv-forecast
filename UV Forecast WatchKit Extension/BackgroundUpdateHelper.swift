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
		
		let preferredDate = preferredDate ?? Date().addingTimeInterval(60 * 60)
		
		let userInfo = ["latitude" : 0.0, "longitude" : 0.0] as (NSSecureCoding & NSObjectProtocol)
		
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: preferredDate, userInfo: userInfo) { (error) in
			
			if error != nil {
				print("Couldn't schedule background update task: \(error!.localizedDescription)")
			}
			
		}
		
	}
	
}
