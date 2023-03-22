//
//  ToDDoListMapper.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/3/11.
//


enum ToDDoListMapper {
    
    static func map(_ list: [ToDDoList]) -> [LocalFeedListGroup] {
        let orderedList = list.sorted(by: { $0.modificationTime < $1.modificationTime })
        return orderedList.map({ $0.localList })
    }
    
}
