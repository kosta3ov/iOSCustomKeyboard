//
//  KeyboardEnvironment.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 08.05.22.
//

import SwiftUI
import Combine

// TODO: Maybe injected inside storage
struct KeyboardButtonSettings {
    let shouldPlayClickSound: Bool
    let shouldProvideHapticFeedback: Bool
}

// TODO: Maybe injected inside storage
struct KeyboardIndentSettings {
    let indent: CGFloat = 4
    let verticalIndent: CGFloat = 8
    let sideKeyboardIndent: CGFloat = 3
    
    // Applied only in last row additional number keyboard
    let extendedIndent: CGFloat = 9
}

struct KeyboardExternalSettings {
    let textDocumentProxy: UITextDocumentProxy?
    // Need to add possibility to change languages button for old iphones
    let shouldChangeKeyboards: Bool
}

final class KeyboardEnvironment: ObservableObject {
        
    var languages: [Language]
    
    var textDocumentProxy: UITextDocumentProxy? {
        return externalSettings.textDocumentProxy
    }
    
    var returnKeyTitle: String {
        textDocumentProxy?.returnKeyTitle ?? "return"
    }

    let indents: KeyboardIndentSettings
    let buttonSettings: KeyboardButtonSettings
    let externalSettings: KeyboardExternalSettings
    
    @ObservedObject
    private var keyboardStorage: KeyboardStorage
    private var bag = Set<AnyCancellable>()
    
    init(keyboardStorage: KeyboardStorage,
         indents: KeyboardIndentSettings,
         buttonSettings: KeyboardButtonSettings,
         externalSettings: KeyboardExternalSettings) {
        self.keyboardStorage = keyboardStorage
        self.languages = keyboardStorage.languages
        self.indents = indents
        self.buttonSettings = buttonSettings
        self.externalSettings = externalSettings
        
        keyboardStorage.objectWillChange.sink { [weak self] in
            self?.languages = keyboardStorage.languages
        }.store(in: &bag)
    }
}
