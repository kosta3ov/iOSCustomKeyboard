//
//  KeyboardEnvironment.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 08.05.22.
//

import SwiftUI
import Combine

final class KeyboardEnvironment: ObservableObject {
    
    @ObservedObject
    var keyboardStorage: KeyboardStorage
    
    var languages: [Language]
    let textDocumentProxy: UITextDocumentProxy?
    let shouldChangeKeyboards: Bool
    let shouldPlayClickSound: Bool
    
    let indent: CGFloat = 6
    let verticalIndent: CGFloat = 4
    let sideKeyboardIndent: CGFloat = 3
    
    // Applied only in last row additional number keyboard
    let extendedIndent: CGFloat = 9
        
    var returnKeyTitle: String {
        textDocumentProxy?.returnKeyTitle ?? "return"
    }
    
    var bag = Set<AnyCancellable>()
    
    init(keyboardStorage: KeyboardStorage,
         textDocumentProxy: UITextDocumentProxy?,
         shouldChangeKeyboards: Bool,
         shouldPlayClickSound: Bool) {
        self.keyboardStorage = keyboardStorage
        self.languages = keyboardStorage.languages
        self.textDocumentProxy = textDocumentProxy
        self.shouldChangeKeyboards = shouldChangeKeyboards
        self.shouldPlayClickSound = shouldPlayClickSound
        
        keyboardStorage.objectWillChange.sink { [weak self] in
            self?.languages = keyboardStorage.languages
        }.store(in: &bag)
    }
}
