//
//  SliderRow.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 03.05.22.
//

import SwiftUI

protocol SliderRowViewModel: AnyObject {
    var title: String { get }
    var lowValue: Float { get }
    var highValue: Float { get }
    var currentValue: Float { get set }
}

struct SliderRow: View {
    
    private var viewModel: SliderRowViewModel
    
    @State private var value: Float
    
    var body: some View {
        VStack() {
            Text(viewModel.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Slider(value: $value, in: viewModel.lowValue ... viewModel.highValue, step: 5) { _ in
                viewModel.currentValue = value
            }
        }
    }
    
    init(viewModel: SliderRowViewModel) {
        self.viewModel = viewModel
        self.value = viewModel.currentValue
    }
}
