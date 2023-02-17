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
    
    func test_update_failsOnUpdateError() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueItem()
        let updateError = anyNSError()
        
        expect(sut, update: listGroup.model, toCompleteWith: .failure(updateError)) {
            store.completeRetrieval(with: [listGroup.local])
            store.completeUpdate(with: updateError)
        }
    }
    
    func test_update_succeedOnUpdatingMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueItem()
        
        expect(sut, update: matchedData.model, toCompleteWith: .success(())) {
            store.completeRetrieval(with: [matchedData.local])
            store.completeUpdateSuccessfully()
        }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve, .update(matchedData.local)])
    }
    
    func test_update_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        let listGroup = uniqueItem()
        var receivedResult = [LocalFeedLoader.UpdateResult]()
        sut?.update(listGroup.model) { receivedResult.append($0) }
        
        sut = nil
        store.completeRetrieval(with: [listGroup.local])
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedUpdate, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: FeedUpdate, update item: FeedListGroup, toCompleteWith expectedResult: FeedUpdate.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for update completion")
        sut.update(item) { receivedResult in
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
