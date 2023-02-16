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
    
    func test_delete_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        let deletionError = anyNSError()
        
        var receivdError: Error?
        let exp = expectation(description: "Wait for delete completion")
        sut.delete(listGroup.model) {
            receivdError = $0
            exp.fulfill()
        }
        
        store.completeDelete(with: deletionError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivdError as NSError?, deletionError as NSError?)
    }
    
    func test_delete_deliversNoErrorOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        
        var receivdError: Error?
        let exp = expectation(description: "Wait for delete completion")
        sut.delete(listGroup.model) {
            receivdError = $0
            exp.fulfill()
        }
        
        store.completeDeletionWithEmptyDatabase()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNil(receivdError)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
}
