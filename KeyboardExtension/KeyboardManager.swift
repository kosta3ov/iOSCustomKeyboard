//
//  KeyboardManager.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 12.04.22.
//

import Foundation

struct Language: RawRepresentable, ExpressibleByStringLiteral, Equatable, Codable {
    
    let rawValue: String
    
    init?(rawValue: String) {
        self.rawValue = rawValue
    }

    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

extension Language {
    static let russian: Language = "rus"
    static let englisch: Language = "eng"
    static let german: Language = "de"
}

struct LanguageKeyboard: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case lang
        case rows
    }
    
    let lang: Language
    let rows: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let langRaw = try values.decode(String.self, forKey: .lang)
        lang = Language(rawValue: langRaw) ?? .englisch
        rows = try values.decode(String.self, forKey: .rows)
    }
}

class KeyboardManager {
    
    enum Error: Swift.Error {
        case fileNotFound
        case languageNotFound
    }
    
    func retrieveKeyboard(for language: Language) throws -> KeyboardViewModel {
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
                ButtonViewModel(character: char)
            }
        }
        
        return KeyboardViewModel(buttons: buttons)
    }
}
