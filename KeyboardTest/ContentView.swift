//
//  ContentView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var viewModel: KeyboardViewModel!
    
    var languages: [Language] = [.englisch, .german, .russian]
    
    var env: KeyboardEnvironment!
    var calculator: KeyboardCalculator!
                
    init() {
        self.env = KeyboardEnvironment(languages: languages,
                                       textDocumentProxy: nil,
                                       shouldChangeKeyboards: false)
        self.viewModel = KeyboardViewModel(keyboardEnvironment: env, buttonsProvider: KeyboardManager())
        self.calculator = KeyboardCalculator(viewModel: viewModel, keyboardEnvironment: env)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color.gray
                
                KeyboardView(viewModel: viewModel, keyboardCalculator: calculator)
                    .frame(width: 300, height: 200)
                    .environmentObject(env)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
