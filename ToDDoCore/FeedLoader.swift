//
//  FeedLoader.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import Foundation

public class FeedLoader {
    private let store: FeedStore
    
    public typealias LoadResult = Result<[FeedListGroup]?, Error>
    public init(store: FeedStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    public func save(completion: @escaping (Error?) -> Void) {
        store.insert(completion: completion)
    }
}
