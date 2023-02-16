//
//  FeedLoader.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/15.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedListGroup]?, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

public protocol FeedCreate {
    typealias Result = (Error?)
    
    func create(_ feed: FeedListGroup, completion: @escaping (Result) -> Void)
}

public protocol FeedDelete {
    typealias Result = (Error?)
    
    func delete(_ feed: FeedListGroup, completion: @escaping (FeedDelete.Result) -> Void)

}
