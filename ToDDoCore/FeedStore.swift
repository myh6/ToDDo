//
//  FeedStore.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import Foundation

public protocol FeedStore {
    typealias RetrievalCompletion = (Result<[FeedListGroup]?, Error>) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
    func insert(_ feed: FeedListGroup, completion: @escaping InsertionCompletion)
}
