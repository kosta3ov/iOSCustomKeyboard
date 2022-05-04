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
    var image: UIImage?
    var padding: Double = 0

    init(character: String, image: UIImage? = nil, padding: Double = 0.0) {
        self.character = character
        self.image = image
        self.padding = padding
    }
}

struct KeyboardButton: View {
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    
    let viewModel: ButtonViewModel
    let onTapSubject: KeyboardSubject
    
    @ViewBuilder
    private var buttonLabel: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(0.5)
        } else {
            Text(String(viewModel.character))
        }
    }

    var body: some View {
        Button {
            onTapSubject.send(viewModel.character)
        } label: {
            buttonLabel
                .padding(EdgeInsets(top: 0, leading: viewModel.padding, bottom: 0, trailing: viewModel.padding))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(6)
    }
}
