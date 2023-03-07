//
//  FeedListGroups.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/12.
//

import Foundation

public struct FeedListGroup: Equatable {
    
    public let id: UUID
    public let listTitle: String
    public let listImage: Data
    public var itemsCount: Int {
        items.count
    }
    public let items: [FeedToDoItem]
    
    public init(id: UUID, listTitle: String, listImage: Data, items: [FeedToDoItem]) {
        self.id = id
        self.listTitle = listTitle
        self.listImage = listImage
        self.items = items
    }
}

public struct FeedToDoItem: Equatable {
    
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


extension FeedListGroup {
    func toLocal() -> LocalFeedListGroup {
        LocalFeedListGroup(id: id, listTitle: listTitle, listImage: listImage, items: items.toCoreModel())
    }
}

extension FeedToDoItem {
    func toLocal() -> LocalToDoItem {
        LocalToDoItem(id: id, title: title, isDone: isDone, expectedDate: expectedDate, finishedDate: finishedDate, priority: priority, url: url, note: note)
    }
}
