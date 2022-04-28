//
//  KeyboardButton.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 15.04.22.
//

import SwiftUI
import Combine

struct ButtonViewModel: Hashable {
    var character: String
    let padding: Double
    
    init(character: String, padding: Double = 0) {
        self.character = character
        self.padding = padding
    }
}

struct KeyboardButton: View {
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    
    let viewModel: ButtonViewModel
    let onTapSubject: KeyboardSubject

    var body: some View {
        Button {
            onTapSubject.send(viewModel.character)
        } label: {
            Text(String(viewModel.character))
                .padding(EdgeInsets(top: 0, leading: viewModel.padding, bottom: 0, trailing: viewModel.padding))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .opacity(1)
                .foregroundColor(Color.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(6)
        .opacity(0.5)
    }
}
