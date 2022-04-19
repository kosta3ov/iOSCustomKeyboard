//
//  KeyboardRow.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 15.04.22.
//

import SwiftUI
import Combine

struct KeyboardRow: View {
    
    let row: [ButtonViewModel]
    let buttonSize: CGSize
    let indent: CGFloat
    let onTapSubject: PassthroughSubject<String, Never>
        
    var body: some View {
        HStack(spacing: indent) {
            ForEach(row, id: \.character) { button in
                KeyboardButton(viewModel: button, onTapSubject: onTapSubject)
                    .frame(width: buttonSize.width,
                           height: buttonSize.height)
                    .background(Color.white)
            }
        }
    }
}
