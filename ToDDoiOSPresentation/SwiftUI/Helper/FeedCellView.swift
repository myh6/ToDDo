//
//  FeedTableView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/23.
//

import SwiftUI

struct FeedCellView: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String
    let selection: () -> Void
    
    var body: some View {
        Button(action: selection) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .shadow(color: colorScheme == .dark ? Color.white : Color.black, radius: 5)
                
                Text(text).font(.subheadline).foregroundColor(.primary)
            }.padding()
        }
    }
}

struct FeedCellView_Previews: PreviewProvider {
    static var previews: some View {
        FeedCellTestingView()
            .previewLayout(.sizeThatFits)
    }
    struct FeedCellTestingView: View {
        @State var count: Int = 0
        
        var body: some View {
            VStack {
                FeedCellView(text: "A text") {
                    count += 1
                }
                Text("Selection count \(count)")
            }.padding()
        }
    }
}

