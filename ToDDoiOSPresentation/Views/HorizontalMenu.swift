//
//  HorizontalMenu.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import SwiftUI

struct HorizontalMenu: View {
    
    @State var store: SelectableMenuStore
    var body: some View {
        HStack {
            ForEach(Array(store.options.enumerated()), id: \.offset) { i, option in
                Button {
                    store.selectOption(at: i)
                } label: {
                    Text(option.text)
                        .foregroundColor(option.isSelected ? Color.blue : Color.gray)
                }

            }
        }
    }
}

struct HorizontalMenu_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalMenu(store: SelectableMenuStore(options: ["A option", "B option", "C option"]))
            .previewLayout(.sizeThatFits)
    }
}
