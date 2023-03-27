//
//  MultiplSelection.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/27.
//

import SwiftUI

struct HorizontalSelectionCell: View {
    @Binding var option: Option
    let selectedColor: Color
    let selection: () -> Void
    
    var body: some View {
        Button(action: {
                selection()
        }) {
            Text(option.text)
                .foregroundColor(option.isSelected ? selectedColor : Color.gray)
                .overlay {
                    Rectangle()
                        .frame(width: 40.0, height: 2.0)
                        .offset(x: 0, y: 20)
                        .foregroundColor(option.isSelected ? selectedColor : .clear)
                        
                }
                
        }.padding()
    }
    
}

struct MultiplSelection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HorizontalSelectionCell(option: .constant(.init(text: "A option")), selectedColor: .indigo, selection: {}).padding()
            
            HorizontalSelectionCell(option: .constant(.init(text: "B option", isSelected: true)), selectedColor: .indigo, selection: {}).padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
