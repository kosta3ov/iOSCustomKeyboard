//
//  KeyboardLanguagesSettings.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 01.05.22.
//

import SwiftUI

class LanguageViewModel: CheckRowViewModel {
   
    var title: String {
        language.rawValue
    }
    
    var isChecked: Bool {
        get {
            languageStorage.languages.contains(language)
        }
        set {
            if newValue {
                languageStorage.addLanguage(language)
            }
            else {
                languageStorage.removeLanguage(language)
            }
        }
    }
    
    private let language: Language
    private let languageStorage: LanguageStorageProtocol
    
    init(language: Language, languageStorage: LanguageStorageProtocol) {
        self.language = language
        self.languageStorage = languageStorage
    }
}

class HeightViewModel: SliderRowViewModel {
    var title: String {
        return "Height"
    }
    
    var lowValue: Float = 200
    var highValue: Float = 300
    var currentValue: Float
    
    init(currentValue: Float) {
        self.currentValue = currentValue
    }
}

class KeyboardLanguageSettingsViewModel {
    
    var languageViewModels: [CheckRowViewModel] {
        languageStorage.allLanguages.map {
            LanguageViewModel(language: $0, languageStorage: languageStorage)
        }
    }
    
    private let languageStorage: LanguageStorageProtocol
        
    init(languageStorage: LanguageStorageProtocol) {
        self.languageStorage = languageStorage
    }
}

struct KeyboardLanguagesSettings: View {
    
    let viewModel: KeyboardLanguageSettingsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.languageViewModels, id: \.self.title) { languageViewModel in
                CheckRow(viewModel: languageViewModel)
            }
        }
        .navigationTitle("Languages")
    }
}

struct CheckRow_Preview: PreviewProvider {
    
    static var previews: some View {
        CheckRow(viewModel: LanguageViewModel(language: .englisch, languageStorage: KeyboardStorage()))
            .previewDevice(.init(rawValue: "iPhone 13"))
    }
    
}
