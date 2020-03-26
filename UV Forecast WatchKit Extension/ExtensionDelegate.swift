//
//  ExtensionDelegate.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
	
	var pendingRefreshBackgroundTask: WKRefreshBackgroundTask?

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                
				let userDefaults = UserDefaults.standard
				guard let latitude = userDefaults["location.latitude"] as? Double, let longitude = userDefaults["location.longitude"] as? Double else {
					NSLog("Refusing to schedule background update: no location saved in UserDefaults")
					backgroundTask.setTaskCompletedWithSnapshot(false)
					return
				}
				
				// Instead of calling a normal load, schedule a background URLSession task to load.
				// This background URLSession task will call the WKURLSessionRefreshBackgroundTask case later in this method.
				print("Requesting background reload…")
				APIClient().scheduleBackgroundUpdate(for: Location(latitude: latitude, longitude: longitude))
                backgroundTask.setTaskCompletedWithSnapshot(true)
				
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
				snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date().startOfNextHour, userInfo: nil)
				
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
				
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
				print("Storing URLSessionRefreshBackgroundTask for later")
				self.pendingRefreshBackgroundTask = urlSessionTask
				
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
				
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
				
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
