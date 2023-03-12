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
                completion(.success(feedItem.toModel()))
            }
        }
    }
}

extension LocalFeedLoader: FeedCreater {
    public typealias SaveResult = FeedCreater.Result
    
    public func create(_ list: FeedListGroup, completion: @escaping (SaveResult) -> Void) {
        store.insert(list.toLocal()) { [weak self] insertionResult in
            guard self != nil else { return }
            switch insertionResult {
            case let .failure(insertionError):
                completion(.failure(insertionError))
                
            case .success:
                completion(.success(()))
            }
        }
    }
    
    public func add(_ item: FeedToDoItem, to list: FeedListGroup, completion: @escaping (SaveResult) -> Void) {
        store.insert(item.toLocal(), to: list.toLocal()) { [weak self] insertionResult in
            guard self != nil else { return }
            switch insertionResult {
            case let .failure(error):
                completion(.failure(error))
                
            case .success:
                completion(.success(()))
            }
        }
    }
    
}

extension LocalFeedLoader: FeedDeleter {
    public typealias DeleteResult = FeedDeleter.Result
    
    public func delete(_ list: FeedListGroup, completion: @escaping (DeleteResult) -> Void) {
        if store.hasItem(with: list.id) {
            store.remove(list.toLocal(), completion: completion)
        }
    }
    
    public func delete(_ item: FeedToDoItem, from list: FeedListGroup, completion: @escaping (Result<Void, Error>) -> Void) {
        if store.hasItem(with: item.id) {
            store.remove(item.toLocal(), from: list.toLocal(), completion: completion)
        }
    }
}

extension LocalFeedLoader: FeedUpdater {
    public typealias UpdateResult = FeedUpdater.Result
    
    public func update(_ list: FeedListGroup, completion: @escaping (UpdateResult) -> Void) {
        if store.hasItem(with: list.id) {
            store.update(list.toLocal(), completion: completion)
        }
    }
    
    public func update(_ item: FeedToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
}

private extension Array where Element == LocalFeedListGroup {
    func toModel() -> [FeedListGroup] {
        return map { FeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, items: $0.items.toPresentedModel()) }
    }
}

private extension Array where Element == FeedListGroup {
    func toLocal() -> [LocalFeedListGroup] {
        return map { LocalFeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, items: $0.items.toCoreModel()) }
    }
}

public extension Array where Element == LocalToDoItem {
    func toPresentedModel() -> [FeedToDoItem] {
        return map {
            FeedToDoItem(id: $0.id, title: $0.title, isDone: $0.isDone, expectedDate: $0.expectedDate, finishedDate: $0.finishedDate, priority: $0.priority, url: $0.url, note: $0.note)
        }
    }
}

public extension Array where Element == FeedToDoItem {
    func toCoreModel() -> [LocalToDoItem] {
        return map {
            LocalToDoItem(id: $0.id, title: $0.title, isDone: $0.isDone, expectedDate: $0.expectedDate, finishedDate: $0.finishedDate, priority: $0.priority, url: $0.url, note: $0.note)
        }
    }
}
