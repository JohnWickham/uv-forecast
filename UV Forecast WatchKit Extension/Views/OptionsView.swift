//
//  OptionsView.swift
//  UV Forecast WatchKit Extension
//
//  Created by John Wickham on 4/14/20.
//  Copyright © 2020 Wickham. All rights reserved.
//

import SwiftUI

/// This class just wraps a set of options in a publisher so the OptionsView can update on changes
class OptionSet: ObservableObject {
	@Published var optionsHelper = OptionsHelper()
	@Published var options = ComplicationDisplayOption.allCases
}

struct OptionsView: View {
	
	@ObservedObject var set = OptionSet()
	
	var body: some View {
		List() {
			Section(header: Text(String("Complications Show…").uppercased()).font(.footnote).foregroundColor(.secondary)) {
				ForEach(set.options, id: \.self) { (option) in
					OptionsListCell(selectedOption: self.$set.optionsHelper.complicationDisplayOption, option: option)
				}
			}
		}
		.navigationBarTitle(Text("Options"))
	}
	
}

struct OptionsListCell<T: Option>: View {
	
	@Binding var selectedOption: T
	var option: T
	
	var body: some View {
		HStack {
			Button(action: {
				self.selectedOption = self.option
			}) { () -> Text in
				Text(self.option.description)
			}
			Spacer()
			if option == selectedOption {
				Image("selection-check").resizable().frame(width: 14, height: 11, alignment: .trailing)
			}
		}
	}
	
}
