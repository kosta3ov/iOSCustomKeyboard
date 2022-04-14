//
//  KeyboardView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI
import Foundation

struct ButtonViewModel: Hashable {
    let character: Character
}

struct KeyboardViewModel {
    let buttons: [[ButtonViewModel]]
}

struct KeyboardButton: View {
    
    @State var viewModel: ButtonViewModel
        
    var body: some View {
        Button {
            print("Tapped button with character: \(viewModel.character)")
        } label: {
            Text(String(viewModel.character))
        }
    }
}

struct KeyboardRow: View {
    
    let row: [ButtonViewModel]
    let buttonSize: CGSize
    let indent: CGFloat
    
    var body: some View {
        HStack(spacing: indent) {
            ForEach(row, id: \.self) { button in
                KeyboardButton(viewModel: button)
                    .frame(width: buttonSize.width,
                           height: buttonSize.height)
                    .background(Color.white)
            }
        }
    }
}

struct KeyboardView: View {
    
    @State var viewModel: KeyboardViewModel
    
    private var rowsCount: Int {
        viewModel.buttons.count
    }

    private var maxRowCount: Int {
        viewModel.buttons.max {
            $0.count < $1.count
        }?.count ?? 0
    }
    
    private let indent: CGFloat = 6
        
    var body: some View {
        VStack(alignment: .center, spacing: indent) {
            ForEach(viewModel.buttons, id: \.self) { row in
                GeometryReader { geo in
                    let buttonSize = calcButtonSize(from: geo)
                    KeyboardRow(row: row,
                                buttonSize: buttonSize,
                                indent: indent)
                        .position(x: geo.frame(in: .local).midX,
                                  y: geo.frame(in: .local).midY)
                        .background(Color.green)
                }
            }
        }
        .background(Color.red)
    }
    
    private func calcButtonSize(from geo: GeometryProxy) -> CGSize {
        return CGSize(width: (geo.size.width - self.indent * (CGFloat(maxRowCount) + 1.0)) / CGFloat(maxRowCount), height: geo.size.height)
    }
}

struct KeyboardView_Previews: PreviewProvider {
    
    static var testKeyboard: KeyboardViewModel {
        try! KeyboardManager().retrieveKeyboard(for: .russian)
    }
    
    static var previews: some View {
        KeyboardView(viewModel: testKeyboard).previewLayout(.fixed(width: 390, height: 300))
    }
}

