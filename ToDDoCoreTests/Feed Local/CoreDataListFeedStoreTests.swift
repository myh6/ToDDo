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
                XCTAssertNil(item)
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
        
        let exp1 = expectation(description: "Wait for insertion result")
        let exp2 = expectation(description: "Wait for retrieval result")
        sut.insert(list) { result in
            exp1.fulfill()
            if case .success = result {
                sut.retrieve { result in
                    let receivedList = try? result.get()
                    XCTAssertEqual([list], receivedList)
                    exp2.fulfill()
                }
            } else {
                XCTFail("Expected to successfully insert \(list), got \(result) instead")
                exp1.fulfill()
            }
        }
        wait(for: [exp1,exp2], timeout: 1.0)
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
    
}
