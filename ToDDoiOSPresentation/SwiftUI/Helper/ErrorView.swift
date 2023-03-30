//
//  ErrorView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/30.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    var body: some View {
        Button {
            retry()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(hue: 1.0, saturation: 0.402, brightness: 0.702))
                Text(message)
                    .font(.body)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.3)
                    .lineLimit(1)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Error! Please refresh", retry: {})
            .previewLayout(.sizeThatFits)
    }
}
