//
//  HorizontalMenu.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import SwiftUI

struct HorizontalMenu: View {
    
    @StateObject var store: SelectableMenuStore
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(store.options.enumerated()), id: \.offset) { i, option in
                    HorizontalSelectionCell(option: $store.options[i]) {
                        store.selectOption(at: i)
                    }
                }
            }
        }
    }
}

struct HorizontalSelectionCell: View {
    @Binding var option: Option
    let selection: () -> Void
    
    var body: some View {
        Button(action: { selection() }) {
            Text(option.text)
                .foregroundColor(option.isSelected ? Color.blue : Color.gray)
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
                HorizontalMenu(store: .init(options: ["A option", "B option", "C option", "D option", "E option", "F option", "G option"], didSelect: {
                    optionText = $0
                }))
                
                Text("Last selected option:" + optionText)
            }.previewLayout(.sizeThatFits)
        }
        
    }
}
