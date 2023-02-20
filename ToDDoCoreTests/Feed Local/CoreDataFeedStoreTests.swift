//
//  CoreDataFeedStoreTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import XCTest
import ToDDoCore

class CoreDataFeedStore: FeedStore {
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))
    }
    
    func insert(_ feed: ToDDoCore.LocalFeedListGroup, completion: @escaping InsertionCompletion) {
        
    }
    
    func remove(_ feed: ToDDoCore.LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        
    }
    
    func update(_ feed: ToDDoCore.LocalFeedListGroup, completion: @escaping UpdateCompletion) {
        
    }
    
    func hasItem(withID: UUID) -> Bool {
        return false
    }
    
}

class CoreDataFeedStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyDatabase() {
        let sut = CoreDataFeedStore()
        
        sut.retrieve { result in
            if case let .success(item) = result {
                XCTAssertNil(item)
            } else {
                XCTFail("Expected no item delivered from empty database")
            }
        }
    }
    
    func test_retrieve_hasNoSideEffectOnEmptyDatabase() {
        let sut = CoreDataFeedStore()
        
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
    
    
}
