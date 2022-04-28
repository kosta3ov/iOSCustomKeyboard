//
//  KeyboardShiftDeleteRow.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 28.04.22.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardShiftDeleteRow: View {
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    @ObservedObject var viewModel: KeyboardViewModel
    
    let keyboardRow: KeyboardRow
    let sideIndent: CGFloat
    let buttonSize: CGSize
    let onTapSubject: KeyboardSubject

    var body: some View {
        HStack(spacing: sideIndent) {
            KeyboardButton(viewModel: ButtonViewModel(character: viewModel.shiftKey),
                           onTapSubject: onTapSubject)
                .environmentObject(keyboardEnvironment)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
            
            keyboardRow
                .environmentObject(keyboardEnvironment)
            
            KeyboardButton(viewModel: ButtonViewModel(character: KeyboardSpecialKey.delete.rawValue),
                           onTapSubject: onTapSubject)
                .environmentObject(keyboardEnvironment)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
        }
    }
}
