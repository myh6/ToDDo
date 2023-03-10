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
    
    static func find(with id: UUID, in context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<ToDDoItem>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ToDDoItem.id), id])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        do {
            let list = try context.fetch(request).first
            return list == nil ? false : true
        } catch {
            return false
        }
    }
    static func item(from localItem: [LocalToDoItem], in context: NSManagedObjectContext) -> NSOrderedSet {
        let item = NSOrderedSet(array: localItem.map { local in
            let managed = ToDDoItem(context: context)
            managed.id = local.id
            managed.url = local.url
            managed.title = local.title
            managed.isDone = local.isDone
            managed.priority = local.priority
            managed.note = local.note
            managed.finishedDate = local.finishedDate
            managed.expectedDate = local.expectedDate
            return managed
        })
        return item
    }
    
    static func item(from localItem: LocalToDoItem, in context: NSManagedObjectContext) -> ToDDoItem {
        let item = ToDDoItem(context: context)
        item.id = localItem.id
        item.title = localItem.title
        item.expectedDate = localItem.expectedDate
        item.finishedDate = localItem.finishedDate
        item.isDone = localItem.isDone
        item.note = localItem.note
        item.priority = localItem.priority
        item.url = localItem.url
        return item
    }
    
    var localItem: LocalToDoItem {
        LocalToDoItem(id: id, title: title, isDone: isDone, expectedDate: expectedDate, finishedDate: finishedDate, priority: priority, url: url, note: note)
    }
}
