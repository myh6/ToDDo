//
//  FeedTableView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/23.
//

import SwiftUI

struct FeedCellView: View {
    let text: String
    let selection: () -> Void
    
    var body: some View {
        Button(action: selection) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.7), radius: 5, x: 0, y: 5)
                
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
            FeedCellView(text: "A text") {
                count += 1
            }
            Text("Selection count \(count)")
        }.padding()
    }
}
