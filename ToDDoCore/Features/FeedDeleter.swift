//
//  FeedDelete.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedDeleter {
    typealias Result = Swift.Result<Void, Error>
    
    func delete(_ list: FeedListGroup, completion: @escaping (FeedDeleter.Result) -> Void)
    func delete(_ item: FeedToDoItem, from list: FeedListGroup, completion: @escaping (FeedDeleter.Result) -> Void)
}
