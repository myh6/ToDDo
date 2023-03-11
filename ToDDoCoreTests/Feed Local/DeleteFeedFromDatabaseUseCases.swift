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
        
        sut.delete(nonMatchedData) { _ in }
        XCTAssertEqual(store.receivedMessage, [.check(false)])
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
