//
//  SaveFeedToDatabaseUseCases.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import XCTest
import ToDDoCore

class SaveFeedToDatabaseUseCases: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    func test_save_requestStoreInsertion() {
        let (sut, store) = makeSUT()
        
        sut.save { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.insert])
    }
    
    func test_save_failsOnSaveError() {
        let (sut, store) = makeSUT()
        let error = anyNSError()
        
        let exp = expectation(description: "Wait for description")
        var receivedError: Error?
        sut.save {
            receivedError = $0
            exp.fulfill()
        }
        store.completeSave(with: error)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, error as NSError)
    }
    
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = FeedLoader(store: store)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
}
