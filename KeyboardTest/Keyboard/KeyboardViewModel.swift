//
//  KeyboardViewModel.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 28.04.22.
//

import UIKit
import SwiftUI
import AVFoundation

final class KeyboardViewModel: ObservableObject {
    
    @ObservedObject var keyboardEnvironment: KeyboardEnvironment
    
    @Published var buttons: KeyboardButtons = [[]]
    @Published var shiftKey: String = KeyboardSpecialKey.shift.rawValue
    @Published var additionalCharactersKey: String = KeyboardSpecialKey.numbers.rawValue
    @Published var isUppercased = false
    
    var isSpecialCharsShowed = false
    
    private var currentLanguage: Language
    private let buttonsProvider: KeyboardButtonsProviderProtocol
    
    private lazy var document: UITextDocumentProxy? = {
        keyboardEnvironment.textDocumentProxy
    }()
    
    init(keyboardEnvironment: KeyboardEnvironment, buttonsProvider: KeyboardButtonsProviderProtocol) {
        self.keyboardEnvironment = keyboardEnvironment
        self.buttonsProvider = buttonsProvider
        self.currentLanguage = keyboardEnvironment.languages.first!
        
        updateButtons()
    }
    
    func isLastRow(row: [ButtonViewModel]) -> Bool {
        buttons.firstIndex(of: row) == buttons.endIndex - 1
    }
    
    func tap(character: String) {
        switch character {
        case KeyboardSpecialKey.shift.rawValue:
            changeButtonsCase()
            
        case KeyboardSpecialKey.delete.rawValue:
            document?.deleteBackward()
            
        case KeyboardSpecialKey.space.rawValue:
            document?.insertText(" ")
            
        case keyboardEnvironment.returnKeyTitle:
            document?.insertText("\n")
            
        case KeyboardSpecialKey.numbers.rawValue:
            switchToNumbersKeyboard()
            
        case KeyboardSpecialKey.others.rawValue:
            switchToAdditionalCharactersKeyboard()
            
        case KeyboardSpecialKey.letters.rawValue:
            switchToLanguageKeyboard()
            
        case "🌐":
            switchNextLanguage()
            
        default:
            insertCharacter(character: character)
        }
    }
    
    func switchToLanguageKeyboard() {
        isSpecialCharsShowed = false
        updateButtons()
        additionalCharactersKey = KeyboardSpecialKey.numbers.rawValue
        shiftKey = KeyboardSpecialKey.shift.rawValue
    }
    
    func switchToNumbersKeyboard() {
        isSpecialCharsShowed = true
        buttons = try! buttonsProvider.retrieveButtons(for: .numbers)
        shiftKey = KeyboardSpecialKey.others.rawValue
        additionalCharactersKey = KeyboardSpecialKey.letters.rawValue
    }
    
    func switchToAdditionalCharactersKeyboard() {
        isSpecialCharsShowed = true
        buttons = try! buttonsProvider.retrieveButtons(for: .additional)
        shiftKey = KeyboardSpecialKey.numbers.rawValue
    }
    
    func changeButtonsCase() {
        for (rowIndex, _) in buttons.enumerated() {
            for (buttonIndex, _) in buttons[rowIndex].enumerated() {
                let oldChar = buttons[rowIndex][buttonIndex].character
                buttons[rowIndex][buttonIndex].character = isUppercased ? oldChar.lowercased() : oldChar.uppercased()
            }
        }
        
        isUppercased.toggle()
    }
    
    func switchNextLanguage() {
        isSpecialCharsShowed = false
        let languages = keyboardEnvironment.languages
        var index = languages.firstIndex(of: currentLanguage)?.advanced(by: 1) ?? languages.startIndex
        if index == languages.endIndex {
            index = languages.startIndex
        }
        currentLanguage = keyboardEnvironment.languages[index]
        
        shiftKey = KeyboardSpecialKey.shift.rawValue
        additionalCharactersKey = KeyboardSpecialKey.numbers.rawValue
        updateButtons()
    }
    
    private func insertCharacter(character: String) {
        if keyboardEnvironment.shouldPlayClickSound {
            AudioServicesPlaySystemSound(1306)
        }
        document?.insertText(character)
    }
    
    private func updateButtons() {
        self.buttons = try! buttonsProvider.retrieveButtons(for: currentLanguage)
    }
}
