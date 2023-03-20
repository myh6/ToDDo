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
}

extension ToDDoList {
    
    @discardableResult
    static func list(from localList: LocalFeedListGroup, and localItem: LocalToDoItem? = nil, in context: NSManagedObjectContext) -> ToDDoList {
        let saveList = ToDDoListMapper.map(item: localItem, with: localList)
        let list = ToDDoList(context: context)
        list.id = saveList.id
        list.title = saveList.listTitle
        list.image = saveList.listImage
        list.item = ToDDoItem.item(from: saveList.items, in: context)
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
        return LocalFeedListGroup(id: id, listTitle: title, listImage: image ?? Data(), items: item.compactMap { ($0 as? ToDDoItem)?.localItem } )
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
