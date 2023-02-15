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
        let listGroup = uniqueFeedListGroup()
        let localListGroup = LocalFeedListGroup(id: listGroup.id, listTitle: listGroup.listTitle, listImage: listGroup.listImage, itemsCount: listGroup.itemsCount)
        
        sut.save (listGroup) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.insert(localListGroup)])
    }
    
    func test_save_failsOnSaveError() {
        let (sut, store) = makeSUT()
        let saveError = anyNSError()
        let listGroup = uniqueFeedListGroup()
        
        let exp = expectation(description: "Wait for description")
        var receivedError: Error?
        sut.save (listGroup) { result in
            if case let .failure(error) = result {
                receivedError = error
                exp.fulfill()
            }
        }
        store.completeSave(with: saveError)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, saveError as NSError)
    }
    
    func test_save_succeedOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        let listGroup = uniqueFeedListGroup()
        let localListGroup = LocalFeedListGroup(id: listGroup.id, listTitle: listGroup.listTitle, listImage: listGroup.listImage, itemsCount: listGroup.itemsCount)
        
        let exp = expectation(description: "Wait for description")
        sut.save (listGroup) { result in
            if case let .failure(error) = result {
                XCTFail("Expected to insert successfully, got \(error) instead")
            }
            exp.fulfill()
        }
        store.completeSave(with: localListGroup)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(store.receivedMessage, [.insert(localListGroup)])
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
