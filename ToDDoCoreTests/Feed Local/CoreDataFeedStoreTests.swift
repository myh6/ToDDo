//
//  CoreDataFeedStoreTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import XCTest
import ToDDoCore

class CoreDataFeedStoreTests: XCTestCase {
    
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
        
        sut.retrieve { result in
            if case let .success(item) = result {
                XCTAssertNil(item)
                sut.retrieve { result in
                    if case let .success(item) = result {
                        XCTAssertNil(item)
                    } else {
                        XCTFail("Expected no item on second retrieve")
                    }
                }
            } else {
                XCTFail("Expected no item on first retrieve")
            }
        }
    }
    
    func test_retrieve_deliversFoundValueOnNonEmptyDatabase() {
        
    }
    
    //MARK: - Helpers
    private func makeSUT() -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(filePath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    
}
