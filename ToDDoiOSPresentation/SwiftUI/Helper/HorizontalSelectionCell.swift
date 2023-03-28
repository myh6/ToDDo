//
//  MultiplSelection.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/27.
//

import SwiftUI

struct HorizontalSelectionCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var option: Option
    let selectedColorLight: Color
    let selectedColorDark: Color
    let selection: () -> Void
    
    var body: some View {
        Button(action: {
                selection()
        }) {
            Text(option.text)
                .font(.subheadline)
                .foregroundColor(option.isSelected ? colorScheme == .dark ? selectedColorDark : selectedColorLight : Color.gray)
                .overlay {
                    Rectangle()
                        .frame(width: 40.0, height: 2.0)
                        .offset(x: 0, y: 20)
                        .foregroundColor(option.isSelected ? colorScheme == .dark ? selectedColorDark : selectedColorLight : .clear)
                        
                }
                
        }.padding()
    }
    
}

struct MultiplSelection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HorizontalSelectionCell(option: .constant(.init(text: "A option")), selectedColorLight: .black, selectedColorDark: .indigo, selection: {}).padding()
            
            HorizontalSelectionCell(option: .constant(.init(text: "B option", isSelected: true)), selectedColorLight: .black, selectedColorDark: .indigo, selection: {}).padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
