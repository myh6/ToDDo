//
//  FeedLoaderUseCaseTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/10.
//

import XCTest
import ToDDoCore

class LoadFeedFromDatabaseUseCasesTests: XCTestCase {
    
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
        let error = anyNSError()
        
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
        let listGroup = uniqueUser()
        
        expect(sut, toCompleteWith: .success(listGroup.models)) {
            store.completeRetrieval(with: listGroup.locals)
        }
    }
   
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        
        var receivedResult = [LocalFeedLoader.LoadResult]()
        sut?.load(completion: { receivedResult.append($0) })
        
        sut = nil
        store.completeRetrievalWithEmptyDatabase()
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
       
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failure(_ error: Error) -> LocalFeedLoader.LoadResult {
        .failure(error)
    }
    
    private func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
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
}
