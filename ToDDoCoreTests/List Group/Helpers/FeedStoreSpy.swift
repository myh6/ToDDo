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
        insertCompletion[index](.failure(error))
    }
    
    func completeSave(with feed: LocalFeedListGroup, at index: Int = 0) {
        insertCompletion[index](.success(()))
    }
}
