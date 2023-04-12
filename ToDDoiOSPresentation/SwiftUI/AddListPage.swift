//
//  AddListPage.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/4/7.
//

import SwiftUI

struct AddListPage: View {
    @State var inputText: String = ""
    @Environment(\.colorScheme) var colorScheme
    var selection: (String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Title")
                TextField(text: $inputText) {
                    Text("Your input")
                }.padding()
            }.padding()
            
            Button(action: { selection(inputText) }) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .overlay(content: {
                        Text("Confirm")
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                    })
                    .frame(minWidth: 300, maxHeight: 60)
                    .shadow(radius: 10)
            }.padding()
        }
    }
}

struct AddListPage_Previews: PreviewProvider {
    static var previews: some View {
        AddListPageTestView()
            .previewLayout(.sizeThatFits)
    }
    
    struct AddListPageTestView: View {
        @State var receivedText: String = ""
        var body: some View {
            VStack {
                AddListPage { value in
                    receivedText = value
                }
                Text("Last received Text: \(receivedText)")
                    .padding()
            }
        }
    }
}
