//
//  KeyboardManager.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 12.04.22.
//

import Foundation

protocol KeyboardButtonsProviderProtocol {
    func retrieveButtons(for language: Language) throws -> KeyboardButtons
}

class KeyboardManager: KeyboardButtonsProviderProtocol {
    
    enum Error: Swift.Error {
        case fileNotFound
        case languageNotFound
    }
    
    func retrieveButtons(for language: Language) throws -> KeyboardButtons {
        guard let url = Bundle.main.url(forResource: "keyboards", withExtension: "json") else {
            throw Error.fileNotFound
        }
        
        let keyboardsData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        let keyboards: [LanguageKeyboard] = try decoder.decode([LanguageKeyboard].self, from: keyboardsData)
        guard let foundKeyboard = keyboards.first(where: { $0.lang == language }) else {
            throw Error.languageNotFound
        }
        
        let rows = foundKeyboard.rows.split(separator: "\n").map { String($0) }
        
        let buttons: [[ButtonViewModel]] = rows.map { row in
            let charArray = Array(row)
            return charArray.map { char in
                ButtonViewModel(character: String(char))
            }
        }
        
        return buttons
    }
    
}
