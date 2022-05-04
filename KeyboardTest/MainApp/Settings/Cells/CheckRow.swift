//
//  CheckRow.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 03.05.22.
//

import SwiftUI

protocol CheckRowViewModel: AnyObject {
    var title: String { get }
    var isChecked: Bool { get set }
}

struct CheckRow: View {
    
    @State private var isChecked: Bool
    private var viewModel: CheckRowViewModel
    
    var body: some View {
        HStack() {
            Text(viewModel.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            if isChecked {
                Image(systemName: "checkmark")
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            isChecked.toggle()
            viewModel.isChecked.toggle()
        }
    }
    
    init(viewModel: CheckRowViewModel) {
        self.viewModel = viewModel
        self.isChecked = viewModel.isChecked
    }
}
