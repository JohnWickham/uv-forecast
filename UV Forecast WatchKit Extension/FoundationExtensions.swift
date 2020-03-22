//
//  FoundationExtensions.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation

extension Date {
	
	var isInPast: Bool {
		Date().distance(to: self) < 0
	}
		
	var isAtMidnight: Bool {
		let calendar = Calendar.current
		let hour = calendar.component(.hour, from: self)
		let minutes = calendar.component(.minute, from: self)
		return hour == 0 && minutes == 0
	}
	
	var isToday: Bool {
		
		let calendar = Calendar.current
		
		let day = calendar.component(.day, from: self)
		let week = calendar.component(.weekOfMonth, from: self)
		let month = calendar.component(.month, from: self)
		let year = calendar.component(.year, from: self)
		
		let now = Date()
		let nowDay = calendar.component(.day, from: now)
		let nowWeek = calendar.component(.weekOfMonth, from: now)
		let nowMonth = calendar.component(.month, from: now)
		let nowYear = calendar.component(.year, from: now)
		
		return (day == nowDay && week == nowWeek && month == nowMonth && year == nowYear)
	}
	
	var shortTimeString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "h a"
		return formatter.string(from: self)
	}
	
	var shortWeekDayString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "E"
		return formatter.string(from: self)
	}

}
