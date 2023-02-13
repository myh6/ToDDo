//
//  ListGroup.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/12.
//

import Foundation

public struct ListGroup: Equatable {
    public let title: String
    public let titleImage: Data?
    public let items: FeedItem
    
    public init(title: String, titleImage: Data?, items: FeedItem) {
        self.title = title
        self.titleImage = titleImage
        self.items = items
    }
}
