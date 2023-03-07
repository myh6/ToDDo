//
//  FeedStore.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import Foundation

public protocol FeedStore {
    typealias RetrievalCompletion = (Result<[LocalFeedListGroup], Error>) -> Void
    typealias InsertionCompletion = (Result<Void, Error>) -> Void
    typealias RemovalCompletion = (Result<Void, Error>) -> Void
    typealias UpdateCompletion = (Result<Void, Error>) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
    
    func insert(_ list: LocalFeedListGroup, completion: @escaping InsertionCompletion)
    func insert(_ item: LocalToDoItem, to list: LocalFeedListGroup, completion: @escaping InsertionCompletion)
    
    func remove(_ list: LocalFeedListGroup, completion: @escaping RemovalCompletion)
    
    func update(_ list: LocalFeedListGroup, completion: @escaping UpdateCompletion)
    
    func hasItem(withID: UUID) -> Bool
}
