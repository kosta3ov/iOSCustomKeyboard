//
//  LanguageStorage.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 03.05.22.
//

import UIKit
import SwiftUI

protocol LanguageStorageProtocol {
    
    var allLanguages: [Language] { get }
    
    var languages: [Language] { get }
    
    func addLanguage(_ language: Language)
    func removeLanguage(_ language: Language)
}

protocol KeyboardAppearanceStorageProtocol {
    
    var height: Double { get set }
    var backgroundImage: UIImage? { get set }
    
}

class KeyboardStorage: ObservableObject {
    
    // TODO: change to user defaults
    var allLanguages: [Language] = [.englisch, .german, .russian]
    
    @Published var languages: [Language] = [.englisch]
    
    var height: Double = 250.0
    var backgroundImage: UIImage?
    
}

extension KeyboardStorage: KeyboardAppearanceStorageProtocol {
    
}

extension KeyboardStorage: LanguageStorageProtocol {
    func addLanguage(_ language: Language) {
        if !languages.contains(language) {
            languages.append(language)
        }
    }
    
    func removeLanguage(_ language: Language) {
        if let index = languages.firstIndex(of: language) {
            languages.remove(at: index)
        }
    }
}
