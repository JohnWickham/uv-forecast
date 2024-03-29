//
//  LocationManager.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/21/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

struct Location {
	var latitude: Double
	var longitude: Double
}

enum LocationError: LocalizedError {
	case permissionNotDetermined
	case permissionDenied
	case failedToLocate
	case unknown
	
	var errorDescription: String? {
		switch self {
		case .permissionNotDetermined:
			return "UV Forecast needs your location to load UV Index informatoin."
		case .permissionDenied:
			return "UV Forecast doesn’t have permisssion to use your location."
		default:
			return "There was a problem finding your location."
		}
	}
	
}

protocol LocationManagerDelegate {
	func locationManagerDidGetLocation(_ result: Result<CLLocation, LocationError>)
}

class LocationManager: NSObject, ObservableObject {

    override init() {
        super.init()
        self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

	@Published var locationStatus: CLAuthorizationStatus = .notDetermined {
        willSet {
            objectWillChange.send()
        }
    }
	
	@Published var locationName: String? {
		willSet {
			objectWillChange.send()
		}
	}
	
	var delegate: LocationManagerDelegate?
	
	func getCurrentLocation() {
		abortIfPermissionDenied()
		self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
	}

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
		abortIfPermissionDenied()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
		abortIfPermissionDenied()
		
		guard let location = locations.last else {
			delegate?.locationManagerDidGetLocation(.failure(.unknown))
			return
		}
		
		getLocationName(location)
		
		// Save the location in UserDefaults
		// This is a workaround for background updates because the userInfo field isn't working correctly for background update calls
		let userDefaults = UserDefaults.standard
		userDefaults["location.latitude"] = location.coordinate.latitude
		userDefaults["location.longitude"] = location.coordinate.longitude
		
		delegate?.locationManagerDidGetLocation(.success(location))
    }
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		delegate?.locationManagerDidGetLocation(.failure(.failedToLocate))
	}
	
	func getLocationName(_ location: CLLocation) {
		
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location) { (placemarks, error) in

			if error != nil {
				self.locationName = nil
			}
			
			self.locationName = placemarks?.first?.locality
			
		}
		
	}
	
	func abortIfPermissionDenied() {
		// For some reason, compressing this three-clause conditional into a single guard statement causes the compiler to stop working.
		if self.locationStatus == .denied {
			delegate?.locationManagerDidGetLocation(.failure(.permissionDenied))
		}
		else if self.locationStatus == .restricted {
			delegate?.locationManagerDidGetLocation(.failure(.permissionDenied))
		}
	}

}
