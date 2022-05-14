//
//  KeyboardAppearanceSettings.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 03.05.22.
//

import SwiftUI

class KeyboardAppearanceSettingsViewModel {
    
    var heightViewModel: SliderRowViewModel {
        HeightViewModel(currentValue: Float(appearanceStorage.height))
    }

    private let appearanceStorage: KeyboardAppearanceStorageProtocol
        
    init(appearanceStorage: KeyboardAppearanceStorageProtocol) {
        self.appearanceStorage = appearanceStorage
    }
}

struct KeyboardAppearanceSettings: View {
    
    var viewModel: KeyboardAppearanceSettingsViewModel
    
    var body: some View {
        List {
            NavigationLink(destination: KeyboardStyleSettings()) {
                Text("Themes")
            }
            SliderRow(viewModel: viewModel.heightViewModel)
        }.navigationBarTitle("Appearance")
    }
}
