//
//  ToDDoListMapper.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/3/11.
//


enum ToDDoListMapper {
    
    static func map(item: LocalToDoItem?, with list: LocalFeedListGroup) -> LocalFeedListGroup {
        guard let item = item else { return list }
        
        var localListItems = list.items
        localListItems.append(item)
        let combineList = LocalFeedListGroup(id: list.id, listTitle: list.listTitle, listImage: list.listImage, items: localListItems)
        
        return list.items.contains(item) ? list : combineList
    }
    
}
