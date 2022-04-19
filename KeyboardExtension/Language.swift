//
//  Language.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 18.04.22.
//

import Foundation

struct Language: RawRepresentable, ExpressibleByStringLiteral, Equatable, Codable, Hashable {
    
    let rawValue: String
    
    init?(rawValue: String) {
        self.rawValue = rawValue
    }

    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

extension Language {
    // Language keyboards
    static let russian: Language = "rus"
    static let englisch: Language = "eng"
    static let german: Language = "de"
    
    // Service keyboards
    static let numbers: Language = "123"
    static let additional: Language = "#+="
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

