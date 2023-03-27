//
//  HorizontalMenu.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import SwiftUI

public struct HorizontalMenu: View {
    
    let selectedColor: Color
    @StateObject var store: SelectableMenuStore
    
    public init(selectedColor: Color, store: SelectableMenuStore) {
        self.selectedColor = selectedColor
        self._store = StateObject(wrappedValue: store)
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(store.options.enumerated()), id: \.offset) { i, option in
                    HorizontalSelectionCell(option: $store.options[i], selectedColor: selectedColor) {
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
                HorizontalMenu(selectedColor: .blue, store: .init(options: ["A option", "B option", "C option", "D option", "E option", "F option", "G option"], didSelect: {
                    optionText = $0
                }))
                
                Text("Last selected option: " + optionText)
            }.previewLayout(.sizeThatFits)
        }
        
    }
}
