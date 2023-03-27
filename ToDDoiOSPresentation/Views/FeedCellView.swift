//
//  FeedTableView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/23.
//

import SwiftUI

struct FeedCellView: View {
    let text: String
    let priority: Priority
    let selection: () -> Void
    
    var body: some View {
        Button(action: selection) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.5), radius: 5)
                
                Text(text).foregroundColor(.black)
            }.padding()
        }
    }
}

struct FeedCellView_Previews: PreviewProvider {
    static var previews: some View {
        FeedCellTestingView()
            .previewLayout(.sizeThatFits)
    }
}

struct FeedCellTestingView: View {
    @State var count: Int = 0
    
    var body: some View {
        VStack {
            FeedCellView(text: "A text", priority: .medium) {
                count += 1
            }
            Text("Selection count \(count)")
        }.padding()
    }
}
