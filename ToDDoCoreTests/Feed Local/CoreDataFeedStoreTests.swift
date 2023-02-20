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
    
    //MARK: - Helpers
    private func makeSUT() -> FeedStore {
        let sut = CoreDataFeedStore()
        trackForMemoryLeaks(sut)
        return sut
    }
    
    
}
