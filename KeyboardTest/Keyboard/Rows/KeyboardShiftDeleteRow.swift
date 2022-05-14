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
    
    @ViewBuilder
    private var shiftButton: some View {
        KeyboardButton(viewModel: ButtonViewModel(character: viewModel.shiftKey, image: UIImage(systemName: viewModel.isUppercased ? "shift.fill" : "shift"), shouldScaleOnTap: false),
                       onTapSubject: onTapSubject)
    }

    var body: some View {
        HStack(spacing: sideIndent) {
            shiftButton
                .environmentObject(keyboardEnvironment)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
            
            keyboardRow
                .environmentObject(keyboardEnvironment)
            
            KeyboardButton(viewModel: ButtonViewModel(character: KeyboardSpecialKey.delete.rawValue, image: UIImage(systemName: "delete.left"), shouldScaleOnTap: false),
                           onTapSubject: onTapSubject)
                .environmentObject(keyboardEnvironment)
                .frame(width: buttonSize.width,
                       height: buttonSize.height)
        }
    }
}
