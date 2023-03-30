//
//  HorizontalMenu.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import SwiftUI

public struct HorizontalMenu: View {
    
    @Environment(\.colorScheme) var colorScheme
    let selectedColorLight: Color
    let selectedColorDark: Color
    @StateObject var store: SelectableMenuStore
    
    public init(selectedColorLight: Color = .black, selectedColorDark: Color = .white, store: SelectableMenuStore) {
        self.selectedColorLight = selectedColorLight
        self.selectedColorDark = selectedColorDark
        self._store = StateObject(wrappedValue: store)
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(store.options.enumerated()), id: \.offset) { i, option in
                    HorizontalSelectionCell(option: $store.options[i], selectedColorLight: selectedColorLight, selectedColorDark: selectedColorDark) {
                        store.selectOption(at: i)
                    }
                }
            }
        }
    }
}

struct HorizontalMenu_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalMenuTestView()
    }
    
    struct HorizontalMenuTestView: View {
        @State var optionText = "none"
        
        var body: some View {
            VStack {
                HorizontalMenu(selectedColorLight: .black, selectedColorDark: .white, store: .init(options: ["A option", "B option", "C option", "D option", "E option", "F option", "G option"], didSelect: {
                    optionText = $0
                }))
                
                Text("Last selected option: " + optionText)
            }.previewLayout(.sizeThatFits)
        }
        
    }
}
