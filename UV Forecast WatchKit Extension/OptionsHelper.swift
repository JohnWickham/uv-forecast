//
//  OptionsHelper.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 4/14/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

class OptionsHelper: ObservableObject {
	
	private var defaults = UserDefaults.standard
	
	var complicationDisplayOption: ComplicationDisplayOption {
		didSet {
			ComplicationController().reloadComplicationTimeline()
			defaults[ComplicationDisplayOption.defaultsKey] = complicationDisplayOption.rawValue
		}
	}
	
	init() {
		let intValue = defaults.integer(forKey: ComplicationDisplayOption.defaultsKey)
		self.complicationDisplayOption = ComplicationDisplayOption(rawValue: intValue) ?? .complicationShowsHighValue
	}
	
	/*
	
	for each type in optionTypes {
		Section {
			for each option in type.options {
				Row(option: option, selectedOption: type.selectedOption)
			}
		}
	}
	
	*/
	
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
