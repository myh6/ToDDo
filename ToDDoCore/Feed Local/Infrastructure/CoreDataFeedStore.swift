//
//  CoreDataFeedStore.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import Foundation

public class CoreDataFeedStore: FeedStore {
    public init() {}
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))
    }
    
    public func insert(_ feed: ToDDoCore.LocalFeedListGroup, completion: @escaping InsertionCompletion) {
        
    }
    
    public func remove(_ feed: ToDDoCore.LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        
    }
    
    public func update(_ feed: ToDDoCore.LocalFeedListGroup, completion: @escaping UpdateCompletion) {
        
    }
    
    public func hasItem(withID: UUID) -> Bool {
        return false
    }
    
}
