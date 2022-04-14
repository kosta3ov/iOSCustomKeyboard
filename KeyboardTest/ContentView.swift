//
//  ContentView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import SwiftUI

struct ContentView: View {
    
    var viewModel: KeyboardViewModel {
        try! KeyboardManager().retrieveKeyboard(for: .englisch)
    }
    
    var body: some View {
        ZStack {
            Color.gray
            KeyboardView(viewModel: viewModel)
                .frame(width: 200, height: 250)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
