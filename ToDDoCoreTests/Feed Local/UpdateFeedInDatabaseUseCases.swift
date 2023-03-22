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

    func test_update_list_doesNotUpdateOnNonMatchedData() {
        let (sut, store) = makeSUT()
        let nonMatchedData = uniqueList()
        
        store.completeWithNoMatchingItem()
        sut.update(nonMatchedData.model, timestamp: Date()) { _ in }

        XCTAssertEqual(store.receivedMessage, [.check(false)])
    }
    
    func test_update_item_doesNotUpdateOnNonMatchedData() {
        let (sut, store) = makeSUT()
        let nonMatchedData = uniqueItem()
        
        store.completeWithNoMatchingItem()
        sut.update(nonMatchedData.model, timestamp: Date()) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.check(false)])
    }

    func test_update_list_failsOnUpdateError() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueList()
        let updateError = anyNSError()

        store.completeWithMatchingItem()
        expect(sut, update: listGroup.model, toCompleteWith: .failure(updateError)) {
            store.completeUpdate(with: updateError)
        }
    }
    
    func test_update_item_failsOnUpdateError() {
        let (sut, store) = makeSUT()
        let item = uniqueItem()
        let updateError = anyNSError()

        store.completeWithMatchingItem()
        expect(sut, update: item.model, toCompleteWith: .failure(updateError)) {
            store.completeUpdate(with: updateError)
        }

    }

    func test_update_list_succeedOnUpdatingMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueList()
        let timestamp = Date()
        
        store.completeWithMatchingItem()
        expect(sut, update: matchedData.model, timestamp: timestamp, toCompleteWith: .success(())) {
            store.completeUpdateSuccessfully()
        }

        XCTAssertEqual(store.receivedMessage, [.check(true), .update(matchedData.local, timestamp)])
    }
    
    func test_update_item_succeedOnUpdatingMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueItem()
        let now = Date()
        
        store.completeWithMatchingItem()
        expect(sut, update: matchedData.model, timestamp: now, toCompleteWith: .success(())) {
            store.completeUpdateSuccessfully()
        }

        XCTAssertEqual(store.receivedMessage, [.check(true), .renew(matchedData.local, now)])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedUpdater, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: FeedUpdater, update list: FeedListGroup, timestamp: Date = Date(), toCompleteWith expectedResult: FeedUpdater.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for update completion")
        sut.update(list, timestamp: timestamp) { receivedResult in
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
    
    private func expect(_ sut: FeedUpdater, update item: FeedToDoItem, timestamp: Date = Date(), toCompleteWith expectedResult: FeedUpdater.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for update completion")
        sut.update(item, timestamp: timestamp) { receivedResult in
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
