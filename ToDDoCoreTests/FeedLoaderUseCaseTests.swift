//
//  FeedLoaderUseCaseTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/10.
//

import XCTest
import ToDDoCore

class FeedLoader {
    let store: FeedStore
    
    typealias LoadResult = Result<[FeedListGroup]?, Error>
    init(store: FeedStore) {
        self.store = store
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
}

class FeedLoaderUserCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    func test_load_requestsStoreRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_loadTwice_requestDataFromDatabaseTwice() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve, .retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let error = anyError()
        
        expect(sut, toCompleteWith: failure(error)) {
            store.completeRetrieval(with: error)
        }
    }
    
    func test_load_deliversNoItemOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(.none)) {
            store.completeRetrievalWithEmptyDatabase()
        }
    }
    
    func test_load_deliversItemOnNonEmptyDatabase() {
        let (sut, store) = makeSUT()
        let feedListGroup = makeFeedListGroups()
        
        expect(sut, toCompleteWith: .success([feedListGroup])) {
            store.completeRetrieval(with: [feedListGroup])
        }
    }
   
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: FeedLoader? = FeedLoader(store: store)
        
        var receivedResult = [FeedLoader.LoadResult]()
        sut?.load(completion: { receivedResult.append($0) })
        
        sut = nil
        store.completeRetrievalWithEmptyDatabase()
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
       
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = FeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failure(_ error: Error) -> FeedLoader.LoadResult {
        .failure(error)
    }
    
    private func anyError() -> Error {
        NSError(domain: "any error", code: 0)
    }
    
    private func makeFeedListGroups(listTitle: String = "a title", listImage: Data = Data("a image".utf8), itemsCount: Int = 0) -> FeedListGroup {
        FeedListGroup(listTitle: listTitle, listImage: listImage, itemsCount: itemsCount)
    }
    
    private func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem, file: file, line: line)
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
                
            default:
                XCTFail("Expected to get Result: \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private class FeedStoreSpy: FeedStore {
        var receivedMessage = [ReceivedMessage]()
        
        private var retrieveCompletion = [RetrievalCompletion]()
        
        enum ReceivedMessage: Equatable {
            case retrieve
        }
        
        func retrieve(completion: @escaping RetrievalCompletion) {
            receivedMessage.append(.retrieve)
            retrieveCompletion.append(completion)
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrieveCompletion[index](.failure(error))
        }
        
        func completeRetrieval(with item: [FeedListGroup], at index: Int = 0) {
            retrieveCompletion[index](.success(item))
        }
        
        func completeRetrievalWithEmptyDatabase(at index: Int = 0) {
            retrieveCompletion[index](.success(.none))
        }
    }
}
