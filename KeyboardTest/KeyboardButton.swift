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
}

struct KeyboardButton: View {
    
    let viewModel: ButtonViewModel
    let onTapSubject: PassthroughSubject<String, Never>

    var body: some View {
        Button {
            onTapSubject.send(viewModel.character)
        } label: {
            Text(String(viewModel.character))
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
