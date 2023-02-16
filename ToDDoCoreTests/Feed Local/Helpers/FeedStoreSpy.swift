//
//  FeedStoreSpy.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import ToDDoCore

class FeedStoreSpy: FeedStore {
    var receivedMessage = [ReceivedMessage]()
    
    private var retrieveCompletion = [RetrievalCompletion]()
    private var insertCompletion = [InsertionCompletion]()
    private var removeCompletion = [RemovalCompletion]()
    
    enum ReceivedMessage: Equatable {
        case retrieve
        case insert(LocalFeedListGroup)
    }
    
    //MARK: - Retrieve
    func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessage.append(.retrieve)
        retrieveCompletion.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrieveCompletion[index](.failure(error))
    }
    
    func completeRetrieval(with item: [LocalFeedListGroup], at index: Int = 0) {
        retrieveCompletion[index](.success(item))
    }
    
    func completeRetrievalWithEmptyDatabase(at index: Int = 0) {
        retrieveCompletion[index](.success(.none))
    }
    
    //MARK: - Insert
    func insert(_ feed: LocalFeedListGroup, completion: @escaping FeedStore.InsertionCompletion) {
        receivedMessage.append(.insert(feed))
        insertCompletion.append(completion)
    }
    
    func completeSave(with error: Error, at index: Int = 0) {
        insertCompletion[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertCompletion[index](.none)
    }
    
    //MARK: - Remove
    func remove(_ feed: LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        removeCompletion.append(completion)
    }
    
    func completeDelete(with error: Error, at index: Int = 0) {
        removeCompletion[index](error)
    }
    
    func completeDeletionWithEmptyDatabase(at index: Int = 0) {
        removeCompletion[index](.none)
    }
}