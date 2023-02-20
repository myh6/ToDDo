//
//  ToDDoItem.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import CoreData

// TODO: - DataModel
@objc(ToDDoItem)
class ToDDoItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var isDone: Bool
    @NSManaged var list: ToDDoList
    @NSManaged var expectedDate: Date?
    @NSManaged var finishedDate: Date?
    @NSManaged var priority: String?
    @NSManaged var url: URL?
    @NSManaged var note: String?
}

extension ToDDoItem {
    var localItem: LocalToDoItem {
        LocalToDoItem(id: id, title: title, isDone: isDone, expectedDate: expectedDate, finishedDate: finishedDate, priority: priority, url: url, note: note)
    }
}
