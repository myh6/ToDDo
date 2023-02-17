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

public protocol FeedUpdate {
    typealias Result = Swift.Result<Void, Error>
    
    func update(_ feed: FeedListGroup, completion: @escaping (FeedUpdate.Result) -> Void)
}
