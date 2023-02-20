//
//  ToDDoUser.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import CoreData

@objc(ToDDoUser)
class ToDDoUser: NSManagedObject {
    @NSManaged var userName: String?
    @NSManaged var lists: NSOrderedSet
}

extension ToDDoUser {
    static func find(in context: NSManagedObjectContext) throws -> ToDDoUser? {
        let request = NSFetchRequest<ToDDoUser>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    var localList: [LocalFeedListGroup] {
        return lists.compactMap { ($0 as? ToDDoList)?.localList }
    }
}
