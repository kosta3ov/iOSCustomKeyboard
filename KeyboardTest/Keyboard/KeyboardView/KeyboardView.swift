//
//  KeyboardView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI
import Combine
import Foundation
import AVFoundation

struct KeyboardView: View {
    
    @EnvironmentObject
    var keyboardEnvironment: KeyboardEnvironment
    
    @ObservedObject
    var viewModel: KeyboardViewModel
    
    private let keyboardCalculator: KeyboardCalculator
    private let onTapSubject = PassthroughSubject<String, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    private var shouldPlayClickSound: Bool {
        nonmutating get {
            keyboardEnvironment.buttonSettings.shouldPlayClickSound
        }
    }
    
    private var shouldProvideHapticFeedback: Bool {
        nonmutating get {
            keyboardEnvironment.buttonSettings.shouldProvideHapticFeedback
        }
    }

    init(viewModel: KeyboardViewModel, keyboardCalculator: KeyboardCalculator) {
        self.viewModel = viewModel
        self.keyboardCalculator = keyboardCalculator
        
        createSubscription().store(in: &bag)
    }
    
    nonmutating func createSubscription() -> AnyCancellable {
        self.onTapSubject.sink {
            if self.shouldPlayClickSound {
                AudioServicesPlaySystemSound(1306)
            }
            
            if self.shouldProvideHapticFeedback {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
            
            viewModel.tap(character: $0)
        }
    }
    
    var body: some View {
        VStack() {
            Spacer().frame(height: keyboardEnvironment.indents.sideKeyboardIndent)
            
            VStack(spacing: keyboardEnvironment.indents.verticalIndent) {
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
                                .frame(maxWidth: geo.size.width - 2 * keyboardEnvironment.indents.sideKeyboardIndent)
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
                                .frame(maxWidth: geo.size.width - 2 * keyboardEnvironment.indents.sideKeyboardIndent)
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
            
            Spacer().frame(height: keyboardEnvironment.indents.sideKeyboardIndent)
        }
        .background(Image("example").resizable())
    }
}
