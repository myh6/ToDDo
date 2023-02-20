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
    @NSManaged var user: ToDDoUser
    @NSManaged var item: NSOrderedSet
}

extension ToDDoList {
    
    var localList: LocalFeedListGroup {
        return LocalFeedListGroup(id: id, listTitle: title, listImage: image ?? Data(), itemsCount: 0)
    }
    
    
}
