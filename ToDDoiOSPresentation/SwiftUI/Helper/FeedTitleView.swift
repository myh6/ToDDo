//
//  FeedMainView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/23.
//

import SwiftUI

struct FeedTitleView: View {
    let title: String
    let date: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Text("\(date)")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
    }
}

struct FeedTitle_Previews: PreviewProvider {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static var previews: some View {

        FeedTitleView(title: "ToDDoList", date: dateFormatter.string(from: Date()))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
}
