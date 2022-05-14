//
//  KeyboardFunctionalRow.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 27.04.22.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardFunctionalRow: View {
    
    private let changeLanguageButtonViewModel = ButtonViewModel(character: "🌐", image: UIImage(systemName: "globe"), shouldScaleOnTap: false, padding: 6)
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    @ObservedObject var viewModel: KeyboardViewModel
    let onTapSubject: KeyboardSubject
    
    var body: some View {
        HStack() {
            Spacer().frame(width: keyboardEnvironment.sideKeyboardIndent)

            HStack(spacing: keyboardEnvironment.indent) {
                KeyboardButton(viewModel: ButtonViewModel(character: viewModel.additionalCharactersKey, shouldScaleOnTap: false), onTapSubject: onTapSubject)
                    .environmentObject(keyboardEnvironment)
                    .frame(minWidth: 50, maxWidth: 50)
                
                KeyboardButton(viewModel: changeLanguageButtonViewModel, onTapSubject: onTapSubject)
                    .environmentObject(keyboardEnvironment)
                    .fixedSize(horizontal: true, vertical: false)
                
                KeyboardButton(viewModel: ButtonViewModel(character: KeyboardSpecialKey.space.rawValue, shouldScaleOnTap: false), onTapSubject: onTapSubject)
                    .environmentObject(keyboardEnvironment)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .layoutPriority(1)
                                
                KeyboardButton(viewModel: ButtonViewModel(character: keyboardEnvironment.returnKeyTitle, shouldScaleOnTap: false, padding: 4), onTapSubject: onTapSubject)
                    .environmentObject(keyboardEnvironment)
                    .frame(minWidth: 60)
            }
            
            Spacer().frame(width: keyboardEnvironment.sideKeyboardIndent)
        }
    }
}
