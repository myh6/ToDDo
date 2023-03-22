//
//  ToDDolist.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import CoreData

@objc(ToDDoList)
class ToDDoList: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var image: Data?
    @NSManaged var item: NSSet
    @NSManaged var modificationTime: Date
}

extension ToDDoList {
    
    @discardableResult
    static func list(from localList: LocalFeedListGroup, and localItem: LocalToDoItem? = nil, timestamp: Date, in context: NSManagedObjectContext) -> ToDDoList {
        let list = ToDDoList(context: context)
        list.id = localList.id
        list.title = localList.listTitle
        list.image = localList.listImage
        list.item = ToDDoItem.item(from: localList.items, timestamp: timestamp, in: context)
        list.modificationTime = timestamp
        if let localItem = localItem {
            list.addToItem(ToDDoItem.item(from: [localItem], timestamp: timestamp.addingTimeInterval(0.01), in: context))
        }
        return list
    }
    
    static func find(with id: UUID, in context: NSManagedObjectContext, completion: @escaping (Result<ToDDoList?, Error>) -> Void) {
        let request = NSFetchRequest<ToDDoList>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ToDDoList.id), id])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        do {
            let list = try context.fetch(request).first
            completion(.success(list))
        } catch {
            completion(.failure(error))
        }
    }
    
    static func find(with id: UUID, in context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<ToDDoList>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ToDDoList.id), id])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        do {
            let list = try context.fetch(request).first
            return list == nil ? false : true
        } catch {
            return false
        }
    }

    var localList: LocalFeedListGroup {
        let items = item.compactMap({ $0 as? ToDDoItem }).sorted(by: { $0.modificationTime < $1.modificationTime })
        return LocalFeedListGroup(id: id, listTitle: title, listImage: image ?? Data(), items: items.map({ $0.localItem }))
    }
    
    
}

// MARK: Generated accessors for item
extension ToDDoList {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: ToDDoItem)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: ToDDoItem)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}
