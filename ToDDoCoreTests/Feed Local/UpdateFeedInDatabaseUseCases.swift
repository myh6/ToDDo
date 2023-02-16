//
//  UpdateFeedInDatabaseUseCases.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/16.
//

import XCTest
import ToDDoCore

class UpdateFeedInDatabaseUseCases: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_update_doesNotUpdateOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        
        sut.update(listGroup.model) { _ in }
        store.completeRetrievalWithEmptyDatabase()

        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_update_doesNotUpdateOnRetrievalError() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        let retrievalError = anyNSError()
        
        sut.update(listGroup.model) { _ in }
        store.completeRetrieval(with: retrievalError)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_update_doesNotUpdateOnNonMatchedData() {
        let (sut, store) = makeSUT()
        let listGroups = uniqueItems()
        let nonMatchedData = uniqueItem()
        
        sut.update(nonMatchedData.model) { _ in }
        store.completeRetrieval(with: listGroups.locals)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_update_updateOnMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueItem()
        
        let exp = expectation(description: "Wait for delete completion")
        var receivedError: Error?
        sut.update(matchedData.model) {
            receivedError = $0
            exp.fulfill()
        }
        
        store.completeRetrieval(with: [matchedData.local])
        store.completeUpdateSuccessfully()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(store.receivedMessage, [.retrieve, .update])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
