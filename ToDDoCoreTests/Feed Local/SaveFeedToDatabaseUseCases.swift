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
        let listGroup = uniqueItem()
        
        sut.save (listGroup.model) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.insert(listGroup.local)])
    }
    
    func test_save_failsOnSaveError() {
        let (sut, store) = makeSUT()
        let saveError = anyNSError()
        
        expect(sut, toCompleteWithError: saveError) {
            store.completeSave(with: saveError)
        }
    }
    
    func test_save_succeedOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: .none) {
            store.completeInsertionSuccessfully()
        }
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: LocalFeedLoader.SaveResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let listGroup = uniqueItem()
        
        let exp = expectation(description: "Wait for description")
        var receivedError: Error?
        sut.save (listGroup.model) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, expectedError as NSError?, file: file, line: line)
    }
}
