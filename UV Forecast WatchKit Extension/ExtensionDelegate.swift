//
//  ExtensionDelegate.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
	
	var pendingBackgroundTask: WKURLSessionRefreshBackgroundTask? = nil

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
		// Automatically update the data.
		DataStore.shared.findLocationAndLoadForecast()
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
                
				guard let location = DataStore.shared.lastSavedLocation else {
					NSLog("Refusing to schedule background update: no location saved in UserDefaults")
					backgroundTask.setTaskCompletedWithSnapshot(false)
					return
				}
				
				// Instead of calling a normal load, schedule a background URLSession task to load.
				// This background URLSession task will call the WKURLSessionRefreshBackgroundTask case later in this method.
				print("Requesting background reload…")
//				backgroundUpdateHelper.startBackgroundUpdateRequest(for: location)
				
				//***
				let backgroundSession = makeBackgroundURLSession(with: "com.Wickham.UV-Forecast.BackgroundUpdate")
				let urlRequest = APIClient().makeURLRequest(for: location)
				backgroundSession.downloadTask(with: urlRequest).resume()
				print("Beginning download task…")
				//***
				
				
                backgroundTask.setTaskCompletedWithSnapshot(false)
				
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
				snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date().nextQuarterHour, userInfo: nil)
				
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
				
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
				print("System completed background task: attaching to background session")
				let _  = makeBackgroundURLSession(with: urlSessionTask.sessionIdentifier)
				self.pendingBackgroundTask = urlSessionTask
				
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
	
	private func makeBackgroundURLSession(with identifier: String) -> URLSession {
		let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
		return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}
	
	class func scheduleNextAppBackgroundRefresh() {
			
		// By default, schedule the next update for the start of the next hour
		let preferredDate = Date().nextQuarterHour

		// The userInfo property isn't working in watchOS 6.2 (17T529)
		// As a workaround, I'm saving the last known location in UserDefaults (see LocationManager)
		
		WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: preferredDate, userInfo: nil) { (error) in
			
			if error != nil {
				print("Couldn't schedule background update task: \(error!.localizedDescription)")
			}
			
			print("Scheduled next background update task for: \(preferredDate)")
			
		}
		
	}

}

extension ExtensionDelegate: URLSessionDownloadDelegate {
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		
		print("Download finished; parsing data…")
		
		do {
				   
			let data = try Data(contentsOf: location)
			APIClient().handleResponse(data: data, response: downloadTask.response, error: downloadTask.error, result: { (result) in

				switch result {
				case .failure(let error):
					print("Background download task failed: ", error)
				case .success(let fetchResult):
					DataStore.shared.currentUVIndex = fetchResult.currentUVIndex
					DataStore.shared.todayHighForecast = fetchResult.dayHighForecast
					DataStore.shared.forecastTimeline = fetchResult.forecastTimeline
				}

				ExtensionDelegate.scheduleNextAppBackgroundRefresh()

			})
		   
	   } catch {
		   print("\(error.localizedDescription)")
	   }
		
	}
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		guard error == nil else {
			print("URL session completed with an error: completing background task without snapshot.")
			self.pendingBackgroundTask?.setTaskCompletedWithSnapshot(false)
			self.pendingBackgroundTask = nil
			return
		}
		
		print("URL session completed; completing background task.")
		pendingBackgroundTask?.setTaskCompletedWithSnapshot(true)
		pendingBackgroundTask = nil
	}
}
