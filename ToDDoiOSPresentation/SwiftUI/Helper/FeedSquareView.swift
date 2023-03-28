//
//  FeedSquareView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import SwiftUI

struct FeedSquareView: View {
    
    let width: CGFloat
    let height: CGFloat
    let title: String
    let number: Int
    let backgroundColor: Color
    let textColor: Color
    
    init(width: CGFloat = 100, height: CGFloat = 100, title: String, number: Int, backgroundColor: Color, textColor: Color) {
        self.width = width
        self.height = height
        self.title = title
        self.number = number
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width, height: height)
                .foregroundColor(backgroundColor)
            
            VStack(spacing: 10.0) {
                Text(title).font(.title).foregroundColor(textColor)
                Text(String(number)).font(.title).foregroundColor(textColor)
            }
        }.padding()
    }
}

struct FeedSquareView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSquareView(width: 200, height: 200, title: "TODAY", number: 6, backgroundColor: .black, textColor: .white).previewLayout(.sizeThatFits)
    }
}
