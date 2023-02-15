//
//  FeedLoader.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedListGroup]?, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

public class LocalFeedLoader {
    private let store: FeedStore
    
    public typealias SaveResult = Result<Void, Error>
    
    public init(store: FeedStore) {
        self.store = store
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
}

extension LocalFeedLoader {
    public func save(_ feed: FeedListGroup, completion: @escaping (SaveResult) -> Void) {
        store.insert(feed, completion: completion)
    }
}
