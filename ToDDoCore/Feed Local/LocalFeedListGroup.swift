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
    public let items: [LocalToDoItem]
    
    public init(id: UUID, listTitle: String, listImage: Data, items: [LocalToDoItem]) {
        self.id = id
        self.listTitle = listTitle
        self.listImage = listImage
        self.items = items
    }
}

public struct LocalToDoItem: Equatable {
    
    public let id: UUID
    public let title: String
    public let isDone: Bool
    public let expectedDate: Date?
    public let finishedDate: Date?
    public let priority: String?
    public let url: URL?
    public let note: String?
    
    public init(id: UUID, title: String, isDone: Bool, expectedDate: Date?, finishedDate: Date?, priority: String?, url: URL?, note: String?) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.expectedDate = expectedDate
        self.finishedDate = finishedDate
        self.priority = priority
        self.url = url
        self.note = note
    }
    
}

