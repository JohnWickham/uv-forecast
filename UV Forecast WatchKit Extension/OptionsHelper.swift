//
//  OptionsHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 4/14/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

class OptionsHelper: ObservableObject {
		
	var complicationDisplayOption: ComplicationDisplayOption {
		get {
			let intValue = UserDefaults.standard[ComplicationDisplayOption.defaultsKey] as? Int ?? 0
			return ComplicationDisplayOption(rawValue: intValue) ?? .complicationShowsHighValue
		}
		set {
			ComplicationController().reloadComplicationTimeline()
			UserDefaults.standard[ComplicationDisplayOption.defaultsKey] = newValue.rawValue
		}
	}
	
}

protocol Option: CaseIterable, Equatable {
	static var defaultsKey: String { get }
	var description: String { get }
}

enum ComplicationDisplayOption: Int, Option {
		
	case complicationShowsHighValue, complicationShowsNextHour
	
	static var defaultsKey: String {
		"com.Wickham.UV-Forecast.Options.ComplicationDisplayOption"
	}
	
	var description: String {
		switch self {
		case .complicationShowsHighValue:
			return "Now & Today’s High"
		default:
			return "Now & Next Hour"
		}
	}
}
