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
    let shouldScaleOnTap: Bool

    init(character: String,
         image: UIImage? = nil,
         shouldScaleOnTap: Bool = true,
         padding: Double = 0.0) {
        self.character = character
        self.image = image
        self.shouldScaleOnTap = shouldScaleOnTap
        self.padding = padding
    }
}

struct KeyboardButton: View {
    
    @EnvironmentObject var keyboardEnvironment: KeyboardEnvironment
    
    let viewModel: ButtonViewModel
    let onTapSubject: KeyboardSubject
        
    @ViewBuilder
    private var button: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(0.5)
        } else {
            Text(String(viewModel.character))
        }
    }
    
    @ViewBuilder
    private var buttonLabel: some View {
        button
            .padding(EdgeInsets(top: 0, leading: viewModel.padding, bottom: 0, trailing: viewModel.padding))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(Color.black)
    }
    
    @ViewBuilder
    private var buttonView: some View {
        Button {
            onTapSubject.send(viewModel.character)
            print("Subject")
        } label: {
            buttonLabel
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(6)
    }
    
    @ViewBuilder
    private func buttonView(isLabelHidden: Bool) -> some View {
        Button {
            onTapSubject.send(viewModel.character)
            print("Subject")
        } label: {
            if isLabelHidden {
                if !buttonTap {
                    buttonLabel
                }
            } else {
                buttonLabel
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(6)
    }
    
    @GestureState private var buttonTap = false

    var body: some View {
        buttonView(isLabelHidden: true)
        .overlay {
            if buttonTap {
                GeometryReader { proxy in
                    let width = proxy.frame(in: .local).width
                    let height = proxy.frame(in: .local).height
                    buttonView(isLabelHidden: false)
                        .scaleEffect(1.4)
                        .position(x: width / 2.0, y: -height/2.0)
                        
                }
            }
        }
        .if(viewModel.shouldScaleOnTap, transform: {
            $0.simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($buttonTap, body: { currentState, state, translation in
                    state = true
                })
            )
        })
    }
}


extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
