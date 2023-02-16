//
//  FeedStore.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import Foundation

public protocol FeedStore {
    typealias RetrievalCompletion = (Result<[LocalFeedListGroup]?, Error>) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RemovalCompletion = (Error?) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
    func insert(_ feed: LocalFeedListGroup, completion: @escaping InsertionCompletion)
    func remove(_ feed: LocalFeedListGroup, completion: @escaping RemovalCompletion)
}
