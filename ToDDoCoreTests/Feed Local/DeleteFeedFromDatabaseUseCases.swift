//
//  DeleteFeedFromDatabaseUseCases.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/16.
//

import XCTest
import ToDDoCore

class DeleteFeedFromDatabaseUseCases: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_delete_doesNotDeleteOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        
        sut.delete(listGroup.model) { _ in }
        store.completeRetrievalWithEmptyDatabase()

        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_delete_doesNotDeleteOnRetrievalError() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        let retrievalError = anyNSError()
        
        sut.delete(listGroup.model) { _ in }
        store.completeRetrieval(with: retrievalError)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_delete_doesNotDeleteOnNonMatchedData() {
        let (sut, store) = makeSUT()
        let listGroups = uniqueItems()
        let nonMatchedData = uniqueItem()
        
        sut.delete(nonMatchedData.model) { _ in }
        store.completeRetrieval(with: listGroups.locals)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_delete_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        let deletionError = anyNSError()
        
        var receivedError: Error?
        let exp = expectation(description: "Wait for delete completion")
        sut.delete(listGroup.model) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(with: [listGroup.local])
        store.completeDelete(with: deletionError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, deletionError)
    }
    
    func test_delete_succeedOnDeletingMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueItem()
        
        let exp = expectation(description: "Wait for delete completion")
        var receivedError: Error?
        sut.delete(matchedData.model) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(with: [matchedData.local])
        store.completeDeletionSuccessfully()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(store.receivedMessage, [.retrieve, .remove(matchedData.local)])
    }
    
    func test_delete_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        let listGroup = uniqueItem()
        var receivedResult = [LocalFeedLoader.DeleteResult]()
        sut?.delete(listGroup.model) { receivedResult.append($0) }
        
        sut = nil
        store.completeRetrieval(with: [listGroup.local])
        
        XCTAssertTrue(receivedResult.isEmpty)
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
