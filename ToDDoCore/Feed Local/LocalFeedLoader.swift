//
//  FeedLoader.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import Foundation

public class LocalFeedLoader {
    private let store: FeedStore
    
    public init(store: FeedStore) {
        self.store = store
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(feedItem):
                completion(.success(feedItem?.toModel()))
            }
        }
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?
    
    public func save(_ feed: FeedListGroup, completion: @escaping (SaveResult) -> Void) {
        store.insert(map(feed), completion: completion)
    }
    
    private func map(_ feed: FeedListGroup) -> LocalFeedListGroup {
        return LocalFeedListGroup(id: feed.id, listTitle: feed.listTitle, listImage: feed.listImage, itemsCount: feed.itemsCount)
    }
}

private extension Array where Element == FeedListGroup {
    func toLocal() -> [LocalFeedListGroup] {
        return map { LocalFeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, itemsCount: $0.itemsCount) }
    }
}

private extension Array where Element == LocalFeedListGroup {
    func toModel() -> [FeedListGroup] {
        return map { FeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, itemsCount: $0.itemsCount) }
    }
}
