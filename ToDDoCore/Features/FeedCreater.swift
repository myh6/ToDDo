//
//  FeedCreate.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedCreater {
    typealias Result = Swift.Result<Void, Error>
    
    func create(_ list: FeedListGroup, completion: @escaping (Result) -> Void)
    
    func add(_ item: FeedToDoItem, to list: FeedListGroup)
}

extension FeedCreater {
    func add(_ item: FeedToDoItem, to list: FeedListGroup) {}
}
