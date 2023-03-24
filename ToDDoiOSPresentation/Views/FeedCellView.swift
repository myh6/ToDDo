//
//  FeedTableView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/23.
//

import SwiftUI

enum Priority {
    case high
    case medium
    case low
    case none
    
    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .blue
        case .none:
            return .gray
        }
    }
}

struct FeedCellView: View {
    let text: String
    let priority: Priority
    let selection: () -> Void
    
    var body: some View {
        Button(action: selection) {
            ZStack {
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: priority.color.opacity(0.8), radius: 5)
                
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
