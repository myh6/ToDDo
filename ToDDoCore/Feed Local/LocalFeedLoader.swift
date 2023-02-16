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
    
    private func map(_ feed: FeedListGroup) -> LocalFeedListGroup {
        return LocalFeedListGroup(id: feed.id, listTitle: feed.listTitle, listImage: feed.listImage, itemsCount: feed.itemsCount)
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
        store.insert(map(feed)) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
}

extension LocalFeedLoader {
    public typealias DeleteResult = Error?
    
    public func delete(_ feed: FeedListGroup, completion: @escaping (DeleteResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(database):
                guard let database = database else {
                    return
                }
                if database.toModel().contains(feed) {
                    self.store.remove(self.map(feed), completion: completion)
                }
            case let .failure(retrievalError):
                completion(retrievalError)
            }
        }
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
