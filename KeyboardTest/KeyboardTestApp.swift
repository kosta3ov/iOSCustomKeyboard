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
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
