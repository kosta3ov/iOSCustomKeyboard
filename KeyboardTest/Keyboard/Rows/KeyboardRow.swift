//
//  KeyboardRow.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 15.04.22.
//

import SwiftUI
import Combine

struct KeyboardRow: View {
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    
    let row: [ButtonViewModel]
    let buttonSize: CGSize
    let onTapSubject: KeyboardSubject
        
    var body: some View {
        HStack(spacing: keyboardEnvironment.indent) {
            ForEach(row, id: \.character) { button in
                KeyboardButton(viewModel: button, onTapSubject: onTapSubject)
                    .frame(width: buttonSize.width, height: buttonSize.height)
                    .environmentObject(keyboardEnvironment)
            }
        }
    }
}
