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

    func test_delete_list_doesNotDeleteOnNonMatchedData() {
        let (sut, store) = makeSUT()
        let nonMatchedData = uniqueList()

        store.completeWithNoMatchingItem()
        sut.delete(nonMatchedData.model) { _ in }

        XCTAssertEqual(store.receivedMessage, [.check(false)])
    }

    func test_delete_list_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueList()
        let deletionError = anyNSError()

        store.completeWithMatchingItem()
        expect(sut, delete: listGroup.model, toCompleteWith: .failure(deletionError)) {
            store.completeDelete(with: deletionError)
        }
    }

    func test_delete_list_succeedOnDeletingMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueList()

        store.completeWithMatchingItem()
        expect(sut, delete: matchedData.model, toCompleteWith: .success(())) {
            store.completeDeletionSuccessfully()
        }

        XCTAssertEqual(store.receivedMessage, [.check(true), .remove(matchedData.local)])
    }
    
    func test_delete_item_doesNotDeleteOnNonMatchedData() {
        let (sut, store) = makeSUT()
        let nonMatchedData = uniqueItem().model

        store.completeWithNoMatchingItem()
        
        sut.delete(nonMatchedData, from: uniqueList().model) { _ in }
        XCTAssertEqual(store.receivedMessage, [.check(false)])
    }
    
    func test_delete_item_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let item = uniqueItem().model
        let deletionError = anyNSError()

        store.completeWithMatchingItem()
        
        expect(sut, delete: item, from: uniqueList().model, toCompleteWith: .failure(deletionError)) {
            store.completeDelete(with: deletionError)
        }
    }
    
    func test_delete_item_succeedOnDeletingMatchedData() {
        let (sut, store) = makeSUT()
        let matchedData = uniqueItem()

        store.completeWithMatchingItem()
        expect(sut, delete: matchedData.model, from: uniqueList().model, toCompleteWith: .success(())) {
            store.completeDeletionSuccessfully()
        }

        XCTAssertEqual(store.receivedMessage, [.check(true), .delete(matchedData.local)])
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedDeleter, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: FeedDeleter, delete list: FeedListGroup, toCompleteWith expectedResult: FeedDeleter.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for delete completion")
        sut.delete(list) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError), .failure(expectedError)):
                
                XCTAssertEqual(receivedError as NSError?, expectedError as NSError?, file: file, line: line)
                
            case (.success, .success):
                break
                
            default:
                XCTFail("Expecte to get result: \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: FeedDeleter, delete item: FeedToDoItem, from list: FeedListGroup, toCompleteWith expectedResult: FeedDeleter.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for delete completion")
        sut.delete(item, from: list) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError), .failure(expectedError)):
                
                XCTAssertEqual(receivedError as NSError?, expectedError as NSError?, file: file, line: line)
                
            case (.success, .success):
                break
                
            default:
                XCTFail("Expecte to get result: \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
            
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
