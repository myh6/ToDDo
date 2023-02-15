//
//  LocalFeedListGroup.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/15.
//

import Foundation

public struct LocalFeedListGroup: Equatable {
    
    public let id: UUID
    public let listTitle: String
    public let listImage: Data
    public let itemsCount: Int
    
    public init(id: UUID, listTitle: String, listImage: Data, itemsCount: Int) {
        self.id = id
        self.listTitle = listTitle
        self.listImage = listImage
        self.itemsCount = itemsCount
    }
}