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
    private var updateCompletion = [UpdateCompletion]()
    private typealias CheckCompletion = (Bool) -> Void
    private var checkComletion = [CheckCompletion]()
    
    struct AddItemList: Equatable {
        let list: LocalFeedListGroup
        let item: LocalToDoItem
    }
    
    enum ReceivedMessage: Equatable {
        case retrieve
        case insert(LocalFeedListGroup)
        case add(AddItemList)
        case remove(LocalFeedListGroup)
        case update(LocalFeedListGroup)
        case check(Bool)
    }
    private(set) var hasData = false
    
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
        retrieveCompletion[index](.success([]))
    }
    
    //MARK: - Insert
    func insert(_ list: LocalFeedListGroup, completion: @escaping FeedStore.InsertionCompletion) {
        receivedMessage.append(.insert(list))
        insertCompletion.append(completion)
    }
    
    func insert(_ item: LocalToDoItem, to list: LocalFeedListGroup, completion: @escaping FeedStore.InsertionCompletion) {
        receivedMessage.append(.add(AddItemList(list: list, item: item)))
        insertCompletion.append(completion)
    }
    
    func completeSave(with error: Error, at index: Int = 0) {
        insertCompletion[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertCompletion[index](.success(()))
    }
    
    //MARK: - Matching
    func hasItem(with id: UUID) -> Bool {
        receivedMessage.append(.check(hasData))
        return hasData
    }
    
    func completeWithMatchingItem() {
        hasData = true
    }
    
    func completeWithNoMatchingItem() {
        hasData = false
    }
    
    //MARK: - Remove
    func remove(_ feed: LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        receivedMessage.append(.remove(feed))
        removeCompletion.append(completion)
    }
    
    func remove(_ item: LocalToDoItem, completion: @escaping RemovalCompletion) {
        
    }
    
    func completeDelete(with error: Error, at index: Int = 0) {
        removeCompletion[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        removeCompletion[index](.success(()))
    }
    
    //MARK: - Update
    func update(_ feed: LocalFeedListGroup, completion: @escaping UpdateCompletion) {
        receivedMessage.append(.update(feed))
        updateCompletion.append(completion)
    }
    
    func completeUpdateSuccessfully(at index: Int = 0) {
        updateCompletion[index](.success(()))
    }
    
    func completeUpdate(with error: Error, at index: Int = 0) {
        updateCompletion[index](.failure(error))
    }
}
