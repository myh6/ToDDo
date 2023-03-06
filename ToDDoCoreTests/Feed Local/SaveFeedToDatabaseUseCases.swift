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
    
    func test_createList_requestStoreInsertion() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueList()
        
        sut.create (listGroup.model) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.insert(listGroup.local)])
    }
    
    func test_createList_failsOnSaveError() {
        let (sut, store) = makeSUT()
        let saveError = anyNSError()
        
        expect(sut, toCompleteWithError: saveError) {
            store.completeSave(with: saveError)
        }
    }
    
    func test_createList_succeedOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: .none) {
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_createList_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        
        var receivedResult = [LocalFeedLoader.SaveResult]()
        sut?.create(uniqueList().model) { receivedResult.append($0) }
        
        sut = nil
        store.completeInsertionSuccessfully()
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedCreater, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: FeedCreater, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for description")
        var receivedError: Error?
        sut.create (uniqueList().model) { result in
            if case let Result.failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}
