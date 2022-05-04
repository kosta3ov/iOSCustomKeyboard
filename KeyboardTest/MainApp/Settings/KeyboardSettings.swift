//
//  KeyboardSettings.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 30.04.22.
//

import SwiftUI

protocol KeyboardFabricProtocol {
    func createSettingsComponent() -> KeyboardSettingsComponentProtocol
}

protocol KeyboardSettingsComponentProtocol {
    var languageSettingsViewModel: KeyboardLanguageSettingsViewModel { get }
    var appearanceSettingsViewModel: KeyboardAppearanceSettingsViewModel { get }
}

class KeyboardFabric: KeyboardFabricProtocol {
    
    private let keyboardStorage = KeyboardStorage()
    
    func createSettingsComponent() -> KeyboardSettingsComponentProtocol {
        KeyboardSettingsComponent(languageSettingsViewModel: KeyboardLanguageSettingsViewModel(languageStorage: keyboardStorage), appearanceSettingsViewModel: KeyboardAppearanceSettingsViewModel(appearanceStorage: keyboardStorage))
    }
    
}

class KeyboardSettingsComponent: KeyboardSettingsComponentProtocol {
    let languageSettingsViewModel: KeyboardLanguageSettingsViewModel
    let appearanceSettingsViewModel: KeyboardAppearanceSettingsViewModel
    
    init(languageSettingsViewModel: KeyboardLanguageSettingsViewModel,
         appearanceSettingsViewModel: KeyboardAppearanceSettingsViewModel) {
        self.languageSettingsViewModel = languageSettingsViewModel
        self.appearanceSettingsViewModel = appearanceSettingsViewModel
    }
}

struct KeyboardSettings: View {
    
    let keyboardSettingsComponent: KeyboardSettingsComponentProtocol
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: KeyboardLanguagesSettings(viewModel: keyboardSettingsComponent.languageSettingsViewModel)) {
                    Text("Languages")
                }
                NavigationLink(destination: KeyboardAppearanceSettings(viewModel: keyboardSettingsComponent.appearanceSettingsViewModel)) {
                    Text("Appearance")
                }
                NavigationLink(destination: ContentView()) {
                    Text("Sound and vibrations")
                }
                NavigationLink(destination: ContentView()) {
                    Text("Buttons")
                }
                NavigationLink(destination: ContentView()) {
                    Text("Typing")
                }
            }.navigationTitle(Text("Settings"))
        }
    }
    
}
