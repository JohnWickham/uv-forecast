//
//  FoundationExtensions.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 3/20/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import Foundation

extension UserDefaults {
	
	subscript(key: String) -> Any? {
		get {
			return self.object(forKey: key)
		}
		set {
			self.set(newValue, forKey: key)
		}
	}
	
}


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
	
	var isInCurrentHour: Bool {
		let calendar = Calendar.current
		let currentHour = calendar.component(.hour, from: Date())
		let hour = calendar.component(.hour, from: self)
		return hour == currentHour
	}
	
	func isInSameDay(as testDate: Date) -> Bool {
		
		let calendar = Calendar.current
		
		let day = calendar.component(.day, from: self)
		let week = calendar.component(.weekOfMonth, from: self)
		let month = calendar.component(.month, from: self)
		let year = calendar.component(.year, from: self)
		
		let otherDay = calendar.component(.day, from: testDate)
		let otherWeek = calendar.component(.weekOfMonth, from: testDate)
		let otherMonth = calendar.component(.month, from: testDate)
		let otherYear = calendar.component(.year, from: testDate)
		
		return (day == otherDay && week == otherWeek && month == otherMonth && year == otherYear)
				
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
	
	var nextQuarterHour: Date {
		
		let currentMinutes = Calendar.current.component(.minute, from: self)
		var nextMinutes: Int = 0
		switch currentMinutes {
		case 0 ..< 15:
			nextMinutes = 15
		case 15 ..< 30:
			nextMinutes = 30
		case 30 ..< 45:
			nextMinutes = 45
		default:
			nextMinutes = 0
		}
		
		return Calendar.current.date(bySetting: .minute, value: nextMinutes, of: self) ?? self.addingTimeInterval(15 * 60)
	}
	
	var timeString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		return formatter.string(from: self)
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

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
