//
//  KeyboardCalculator.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 28.04.22.
//

import Foundation
import SwiftUI

final class KeyboardCalculator: ObservableObject {
    
    private let keyboardEnvironment: KeyboardEnvironment
    private let viewModel: KeyboardViewModel
    
    private var rowsCount: Int {
        viewModel.buttons.count
    }

    private var maxRowCount: Int {
        viewModel.buttons.max {
            $0.count < $1.count
        }?.count ?? 0
    }
    
    init(viewModel: KeyboardViewModel, keyboardEnvironment: KeyboardEnvironment) {
        self.viewModel = viewModel
        self.keyboardEnvironment = keyboardEnvironment
    }
    
    func calcButtonSize(from geo: GeometryProxy) -> CGSize {
        return CGSize(width: (geo.size.width - keyboardEnvironment.indent * (CGFloat(maxRowCount) - 1.0) - 2 * keyboardEnvironment.sideKeyboardIndent) / CGFloat(maxRowCount), height: geo.size.height)
    }
    
    // Calculating last row side button size and side indent for shift and delete buttons
    func calsLastRowSideButtonSize(from geo: GeometryProxy, row: [ButtonViewModel]) -> (CGSize, CGFloat) {
        let buttonSize = calcButtonSize(from: geo)
        let allButtonsWidth: CGFloat = buttonSize.width * CGFloat(row.count) + (CGFloat(row.count) - 1.0) * keyboardEnvironment.indent
        let sideAvailableWidth: CGFloat = (geo.size.width - allButtonsWidth - 2.0 * keyboardEnvironment.sideKeyboardIndent) / 2.0
        
        let sideButtonWidth = max(min(sideAvailableWidth, 1.3 * buttonSize.width), buttonSize.width)
        
        if sideAvailableWidth - sideButtonWidth < keyboardEnvironment.indent {
            return (buttonSize, keyboardEnvironment.indent)
        }
        else {
            let sideIndent = sideAvailableWidth - sideButtonWidth
            return (CGSize(width: sideButtonWidth, height: buttonSize.height), sideIndent)
        }
    }
    
    // Calculating size for last row in additional 123 keyboard
    func calcLastRowAdditionalButtonSize(from geo: GeometryProxy, row: [ButtonViewModel]) -> CGSize {
        return CGSize(width: (geo.size.width - keyboardEnvironment.indent * CGFloat(row.count - 1) - 2 * keyboardEnvironment.extendedIndent - 2 * keyboardEnvironment.sideKeyboardIndent) / CGFloat(row.count + 2), height: geo.size.height)
    }
}
