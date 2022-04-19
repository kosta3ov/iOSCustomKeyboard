//
//  KeyboardView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI
import Combine
import Foundation

typealias KeyboardButtons = [[ButtonViewModel]]

final class KeyboardViewModel: ObservableObject {
    
    @Published var buttons: KeyboardButtons = [[]]
    @Published var shiftKey: String = "⇧"
    @Published var additionalCharactersKey: String = "123"
    
    private let language: Language
    private let textDocumentProxy: UITextDocumentProxy?
    private let buttonsProvider: KeyboardButtonsProviderProtocol
    
    private var isUppercased = false

    var returnKeyTitle: String {
        switch textDocumentProxy?.returnKeyType {
        case .go:
            return "Go";
        case .yahoo, .google, .search:
            return "Search";
        case .join:
            return "Join";
        case .next:
            return "Next";
        case .route:
            return "Route";
        case .send:
            return "Send";
        case .done:
            return "Done";
        case .emergencyCall:
            return "Call";
        case .continue:
            return "Continue";
        default:
            return "return";
        }
    }
    
    init(language: Language,
         textDocumentProxy: UITextDocumentProxy?,
         buttonsProvider: KeyboardButtonsProviderProtocol) {
        self.language = language
        self.buttons = try! buttonsProvider.retrieveButtons(for: language)
        self.textDocumentProxy = textDocumentProxy
        self.buttonsProvider = buttonsProvider
    }
    
    func tap(character: String) {
        switch character {
        case "⇧":
            changeButtonsCase()
        case "⌫":
            textDocumentProxy?.deleteBackward()
        case "Space":
            textDocumentProxy?.insertText(" ")
        case returnKeyTitle:
            textDocumentProxy?.insertText("\n")
        case "123":
            switchToNumbersKeyboard()
        case "#+=":
            switchToAdditionalCharactersKeyboard()
        case "ABC":
            switchToLanguageKeyboard()
        default:
            textDocumentProxy?.insertText(character)
        }
    }
    
    func switchToLanguageKeyboard() {
        buttons = try! buttonsProvider.retrieveButtons(for: language)
        additionalCharactersKey = "123"
        shiftKey = "⇧"
    }
    
    func switchToNumbersKeyboard() {
        buttons = try! buttonsProvider.retrieveButtons(for: .numbers)
        shiftKey = "#+="
        additionalCharactersKey = "ABC"
    }
    
    func switchToAdditionalCharactersKeyboard() {
        buttons = try! buttonsProvider.retrieveButtons(for: .additional)
        shiftKey = "123"
    }
    
    func changeButtonsCase() {
        for (rowIndex, _) in buttons.enumerated() {
            for (buttonIndex, _) in buttons[rowIndex].enumerated() {
                let oldChar = buttons[rowIndex][buttonIndex].character
                buttons[rowIndex][buttonIndex].character = isUppercased ? oldChar.lowercased() : oldChar.uppercased()
            }
        }
        
        isUppercased.toggle()
    }
}

struct KeyboardView: View {
    
    @ObservedObject var viewModel: KeyboardViewModel
    
    private let onTapSubject = PassthroughSubject<String, Never>()
    
    private var rowsCount: Int {
        viewModel.buttons.count
    }

    private var maxRowCount: Int {
        viewModel.buttons.max {
            $0.count < $1.count
        }?.count ?? 0
    }
    
    private let indent: CGFloat = 6
    private var bag = Set<AnyCancellable>()

    init(viewModel: KeyboardViewModel) {
        self.viewModel = viewModel
        
        
        onTapSubject.sink {
            viewModel.tap(character: $0)
        }.store(in: &bag)
    }
    
    var body: some View {
        VStack(spacing: indent) {
            ForEach(viewModel.buttons, id: \.self) { row in
                GeometryReader { geo in
                    let buttonSize = calcButtonSize(from: geo)
                    let keyboardRow = KeyboardRow(row: row,
                                buttonSize: buttonSize,
                                indent: indent,
                                onTapSubject: onTapSubject)
                        
                    if viewModel.buttons.firstIndex(of: row) ==  viewModel.buttons.endIndex - 1 {
                        HStack {
                            KeyboardButton(viewModel: ButtonViewModel(character: viewModel.shiftKey), onTapSubject: onTapSubject)
                                .background(Color.white)

                            keyboardRow
                            
                            KeyboardButton(viewModel: ButtonViewModel(character: "⌫"), onTapSubject: onTapSubject)
                                .background(Color.white)

                        }.position(x: geo.frame(in: .local).midX,
                                   y: geo.frame(in: .local).midY)
                         .background(Color.green)
                    } else {
                        keyboardRow
                            .position(x: geo.frame(in: .local).midX,
                                             y: geo.frame(in: .local).midY)
                            .background(Color.green)
                    }
                }
            }
            HStack {
                KeyboardButton(viewModel: ButtonViewModel(character: viewModel.additionalCharactersKey), onTapSubject: onTapSubject)
                    .background(Color.white)
                
                KeyboardButton(viewModel: ButtonViewModel(character: "Space"), onTapSubject: onTapSubject)
                    .frame(maxWidth: 100)
                    .background(Color.white)
                    .layoutPriority(1)
                
                KeyboardButton(viewModel: ButtonViewModel(character: "."), onTapSubject: onTapSubject)
                    .frame(minWidth: 30)
                    .background(Color.white)
                
                KeyboardButton(viewModel: ButtonViewModel(character: viewModel.returnKeyTitle), onTapSubject: onTapSubject)
                    .background(Color.white)
            }
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
        }
        .background(Color.red)
        Spacer()
    }
    
    private func calcButtonSize(from geo: GeometryProxy) -> CGSize {
        return CGSize(width: (geo.size.width - self.indent * (CGFloat(maxRowCount) + 1.0)) / CGFloat(maxRowCount), height: geo.size.height)
    }
}
