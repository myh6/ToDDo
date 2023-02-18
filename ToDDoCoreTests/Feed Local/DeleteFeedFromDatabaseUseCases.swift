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
        
        expect(sut, delete: listGroup.model, toCompleteWith: .failure(deletionError)) {
            store.completeRetrieval(with: [listGroup.local])
            store.completeDelete(with: deletionError)
        }
    }
    
    func test_delete_succeedOnDeletingMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueItem()
        
        expect(sut, delete: matchedData.model, toCompleteWith: .success(())) {
            store.completeRetrieval(with: [matchedData.local])
            store.completeDeletionSuccessfully()
        }
        
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
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedDeleter, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: FeedDeleter, delete item: FeedListGroup, toCompleteWith expectedResult: FeedDeleter.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for delete completion")
        sut.delete(item) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError), .failure(expectedError)):
                
                XCTAssertEqual(receivedError as NSError?, expectedError as NSError?)
                
            case (.success, .success):
                break
                
            default:
                XCTFail("Expecte to get result: \(expectedResult), got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
