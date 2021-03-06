//
//  KeyboardTestApp.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI

enum AppStorageKey: String {
    case keyboardLanguage = "keyboard_language"
}

@main
struct KeyboardTestApp: App {
    
    private let fabric = KeyboardFabric()
        
    var body: some Scene {
        WindowGroup {
            KeyboardSettings(keyboradStorage: fabric.keyboardStorage, keyboardSettingsComponent: fabric.createSettingsComponent())
        }
    }
}
