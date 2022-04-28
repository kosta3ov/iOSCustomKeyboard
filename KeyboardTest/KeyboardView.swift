//
//  KeyboardView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI
import Combine
import Foundation

final class KeyboardEnvironment: ObservableObject {
    
    let languages: [Language]
    let textDocumentProxy: UITextDocumentProxy?
    let shouldChangeKeyboards: Bool
    
    let indent: CGFloat = 6
    let sideKeyboardIndent: CGFloat = 3
    
    // Applied only in last row additional number keyboard
    let extendedIndent: CGFloat = 9
        
    var returnKeyTitle: String {
        textDocumentProxy?.returnKeyTitle ?? "return"
    }
    
    init(languages: [Language],
         textDocumentProxy: UITextDocumentProxy?,
         shouldChangeKeyboards: Bool) {
        self.languages = languages
        self.textDocumentProxy = textDocumentProxy
        self.shouldChangeKeyboards = shouldChangeKeyboards
    }
}

struct KeyboardView: View {
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    @ObservedObject var viewModel: KeyboardViewModel
    
    private var bag = Set<AnyCancellable>()
    private let keyboardCalculator: KeyboardCalculator
    private let onTapSubject = PassthroughSubject<String, Never>()

    init(viewModel: KeyboardViewModel, keyboardCalculator: KeyboardCalculator) {
        self.viewModel = viewModel
        self.keyboardCalculator = keyboardCalculator
        
        onTapSubject.sink {
            viewModel.tap(character: $0)
        }.store(in: &bag)
    }
    
    var body: some View {
        VStack() {
            Spacer().frame(height: keyboardEnvironment.sideKeyboardIndent)
            
            VStack(spacing: keyboardEnvironment.indent) {
                ForEach(viewModel.buttons, id: \.self) { row in
                    GeometryReader { geo in
                        let buttonSize = keyboardCalculator.calcButtonSize(from: geo)
                        let keyboardRow = KeyboardRow(row: row,
                                                      buttonSize: buttonSize,
                                                      onTapSubject: onTapSubject)
                            
                        if viewModel.isSpecialCharsShowed && viewModel.isLastRow(row: row) {
                            let lastRowButtonSize = keyboardCalculator.calcLastRowAdditionalButtonSize(from: geo, row: row)
                            
                            KeyboardServiceLastRow(viewModel: viewModel,
                                                   row: row, buttonSize: lastRowButtonSize,
                                                   onTapSubject: onTapSubject)
                                .position(x: geo.frame(in: .local).midX,
                                          y: geo.frame(in: .local).midY)
                                .frame(maxWidth: geo.size.width - 2 * keyboardEnvironment.sideKeyboardIndent)
                        }
                        else if viewModel.isLastRow(row: row) {
                            let (lastRowSideButtonSize, sideIndent) = keyboardCalculator.calsLastRowSideButtonSize(from: geo, row: row)
                            KeyboardShiftDeleteRow(viewModel: viewModel,
                                                   keyboardRow: keyboardRow,
                                                   sideIndent: sideIndent,
                                                   buttonSize: lastRowSideButtonSize,
                                                   onTapSubject: onTapSubject)
                                .environmentObject(keyboardEnvironment)
                                .position(x: geo.frame(in: .local).midX,
                                          y: geo.frame(in: .local).midY)
                                .frame(maxWidth: geo.size.width - 2 * keyboardEnvironment.sideKeyboardIndent)
                        } else {
                            keyboardRow
                                .environmentObject(keyboardEnvironment)
                                .position(x: geo.frame(in: .local).midX,
                                          y: geo.frame(in: .local).midY)
                        }
                    }
                }
                KeyboardFunctionalRow(viewModel: viewModel, onTapSubject: onTapSubject)
                    .environmentObject(keyboardEnvironment)
                    .frame(height: 40)
            }
            
            Spacer().frame(height: keyboardEnvironment.sideKeyboardIndent)
        }
        .background(Image("example").resizable())
    }
}
