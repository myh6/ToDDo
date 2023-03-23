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
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(.displayP3, red: 0.255, green: 0.0, blue: 0.0))
                .multilineTextAlignment(.leading)
            
            Text("\(date)")
                .foregroundColor(Color(red: 0.3764705882352941, green: 0.39215686274509803, blue: 0.4392156862745098))
                .multilineTextAlignment(.leading)
        }.padding()
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
