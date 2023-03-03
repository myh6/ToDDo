//
//  CoreDataFeedStoreTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import XCTest
import ToDDoCore

class CoreDataListFeedStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyDatabase() {
        let sut = makeSUT()
        
        sut.retrieve { result in
            if case let .success(item) = result {
                XCTAssertTrue(item.isEmpty)
            } else {
                XCTFail("Expected no item delivered from empty database")
            }
        }
    }
    
    func test_retrieve_hasNoSideEffectOnEmptyDatabase() {
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for retrieval result")
        sut.retrieve { result in
            if case let .success(item) = result {
                XCTAssertTrue(item.isEmpty)
                sut.retrieve { result in
                    if case let .success(item) = result {
                        XCTAssertTrue(item.isEmpty)
                    } else {
                        XCTFail("Expected no item on second retrieve")
                    }
                    exp.fulfill()
                }
            } else {
                XCTFail("Expected no item on first retrieve")
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_deliversFoundListValueOnNonEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        insert(list, to: sut)
        
        let exp = expectation(description: "Wait for retrieval result")
        sut.retrieve { result in
            let receivedList = try? result.get()
            XCTAssertEqual(receivedList, [list])
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(filePath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func uniquePureList() -> (model: FeedListGroup, local: LocalFeedListGroup) {
        let model = uniqueFeedListGroup(items: [])
        let local = LocalFeedListGroup(id: model.id, listTitle: model.listTitle, listImage: model.listImage, items: [])
        return (model, local)
    }
    
    @discardableResult
    private func insert(_ list: LocalFeedListGroup, to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for insertion")
        var insertionError: Error?
        sut.insert(list) { result in
            if case let Result.failure(error) = result {
                insertionError = error
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
}
