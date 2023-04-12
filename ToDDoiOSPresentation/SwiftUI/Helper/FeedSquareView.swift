//
//  FeedSquareView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import SwiftUI

struct FeedSquareView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let width: CGFloat
    let height: CGFloat
    let title: String
    let number: Int
    
    init(width: CGFloat = 100, height: CGFloat = 100, title: String, number: Int) {
        self.width = width
        self.height = height
        self.title = title
        self.number = number
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width, height: height)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            
            VStack(spacing: 10.0) {
                Text(title).font(.headline).foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                Text(String(number)).font(.title).foregroundColor(colorScheme == .dark ? Color.black : Color.white)
            }
        }
    }
}

struct FeedSquareView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSquareView(width: 200, height: 200, title: "TODAY", number: 6).previewLayout(.sizeThatFits)
    }
}
