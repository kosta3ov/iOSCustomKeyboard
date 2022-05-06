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
                    SettingsRow(viewModel: KeyboardSettingsRowViewModel(title: "Languages", subtitle: "English, Русский", image: UIImage(systemName: "globe")))
                }
                NavigationLink(destination: KeyboardAppearanceSettings(viewModel: keyboardSettingsComponent.appearanceSettingsViewModel)) {
                    SettingsRow(viewModel: KeyboardSettingsRowViewModel(title: "Appearance", subtitle: "Themes and height", image: UIImage(systemName: "theatermasks.circle")))
                }
                NavigationLink(destination: ContentView()) {
                    SettingsRow(viewModel: KeyboardSettingsRowViewModel(title: "Sound and vibrations", subtitle: nil, image: UIImage(systemName: "speaker.circle")))
                }
                NavigationLink(destination: ContentView()) {
                    SettingsRow(viewModel: KeyboardSettingsRowViewModel(title: "Buttons", subtitle: nil, image: UIImage(systemName: "a.circle")))
                }
                NavigationLink(destination: ContentView()) {
                    SettingsRow(viewModel: KeyboardSettingsRowViewModel(title: "Typing", subtitle: "Autocorrection", image: UIImage(systemName: "pencil.circle.fill")))
                }
            }.navigationTitle(Text("Settings"))
        }
    }
}

