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

extension LocalFeedLoader: FeedCreater {
    public typealias SaveResult = FeedCreater.Result
    
    public func create(_ feed: FeedListGroup, completion: @escaping (SaveResult) -> Void) {
        store.insert(map(feed)) { [weak self] insertionResult in
            guard self != nil else { return }
            switch insertionResult {
            case let .failure(insertionError):
                completion(.failure(insertionError))
                
            case .success:
                completion(.success(()))
            }
        }
    }
    
}

extension LocalFeedLoader: FeedDeleter {
    public typealias DeleteResult = FeedDeleter.Result
    
    public func delete(_ feed: FeedListGroup, completion: @escaping (DeleteResult) -> Void) {
        if store.hasItem(withID: feed.id) {
            store.remove(map(feed), completion: completion)
        }
    }
}

extension LocalFeedLoader: FeedUpdater {
    public typealias UpdateResult = FeedUpdater.Result
    
    public func update(_ feed: FeedListGroup, completion: @escaping (UpdateResult) -> Void) {
        store.retrieve() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(database):
                if let database = database?.toModel(), FeedMatchingPolicy.hasData(self.map(feed), in: database.toLocal()) {
                    self.store.update(self.map(feed), completion: completion)
                }
            case let .failure(retrievalError):
                completion(.failure(retrievalError))
            }
        }
    }
}

private extension Array where Element == LocalFeedListGroup {
    func toModel() -> [FeedListGroup] {
        return map { FeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, itemsCount: $0.itemsCount) }
    }
}

private extension Array where Element == FeedListGroup {
    func toLocal() -> [LocalFeedListGroup] {
        return map { LocalFeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, itemsCount: $0.itemsCount) }
    }
}
