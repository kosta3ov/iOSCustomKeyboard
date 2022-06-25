//
//  KeyboardShiftDeleteRow.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 28.04.22.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardServiceLastRow: View {
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    @ObservedObject var viewModel: KeyboardViewModel
    
    let row: [ButtonViewModel]
    let buttonSize: CGSize
    let onTapSubject: KeyboardSubject

    var body: some View {
        HStack(spacing: keyboardEnvironment.indents.extendedIndent) {
            KeyboardButton(viewModel: ButtonViewModel(character: viewModel.shiftKey),
                           onTapSubject: onTapSubject)
                .environmentObject(keyboardEnvironment)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
            
            KeyboardRow(row: row, buttonSize: buttonSize, onTapSubject: onTapSubject)
                .environmentObject(keyboardEnvironment)
            
            KeyboardButton(viewModel: ButtonViewModel(character: KeyboardSpecialKey.delete.rawValue),
                           onTapSubject: onTapSubject)
                .environmentObject(keyboardEnvironment)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
        }
    }
}
