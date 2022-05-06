//
//  SwiftUIView.swift
//  KeyboardTest
//
//  Created by Konstantin Trekhperstov on 05.05.22.
//

import SwiftUI

protocol SettingRowViewModel {
    var title: String { get }
    var subtitle: String? { get }
    var image: UIImage? { get }
}


struct SettingsRow: View {
    
    let viewModel: SettingRowViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding(6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.headline)
                if let subtitle = viewModel.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                }
            }
        }.padding([.top, .trailing, .bottom], 16)
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRow(viewModel: KeyboardSettingsRowViewModel(title: "Languages", subtitle: "English, Русский", image: UIImage(systemName: "globe")))
    }
}
