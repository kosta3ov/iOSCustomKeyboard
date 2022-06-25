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
        
    @ObservedObject
    var env: KeyboardEnvironment
    
    var calculator: KeyboardCalculator!
                    
    init(keyboardStorage: KeyboardStorage) {
        self.env = KeyboardEnvironment(keyboardStorage: keyboardStorage,
                                       indents: KeyboardIndentSettings(),
                                       buttonSettings: KeyboardButtonSettings(shouldPlayClickSound: true, shouldProvideHapticFeedback: false),
                                       externalSettings: KeyboardExternalSettings(textDocumentProxy: nil, shouldChangeKeyboards: false))
        self.viewModel = KeyboardViewModel(keyboardEnvironment: env, buttonsProvider: KeyboardManager())
        self.calculator = KeyboardCalculator(viewModel: viewModel, keyboardEnvironment: env)
    }
    
    var body: some View {
        ZStack {
            Color.gray
            VStack {
                Spacer().layoutPriority(1)
                KeyboardView(viewModel: viewModel, keyboardCalculator: calculator)
                    .frame(width: UIScreen.main.bounds.width, height: 216)
                    .environmentObject(env)
            }
        }
    }
}

