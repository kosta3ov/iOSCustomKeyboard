//
//  ContentView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI

struct ContentView: View {
    
    var viewModel: KeyboardViewModel {
        KeyboardViewModel(language: .russian, textDocumentProxy: nil, buttonsProvider: KeyboardManager())
    }
    
    var languages: [Language] = [.englisch, .german, .russian]
    
    @AppStorage("keyboard_language", store: UserDefaults(suiteName: "group.KeyboardExtension")) var keyboardLanguage: String = "eng"
    
    var body: some View {
        VStack {
            ZStack {
                Color.gray
                KeyboardView(viewModel: viewModel)
                    .frame(width: 250, height: 200)
                    
            }
            
            Picker("Choose language", selection: $keyboardLanguage) {
                ForEach(languages, id: \.self) {
                    Text($0.rawValue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
