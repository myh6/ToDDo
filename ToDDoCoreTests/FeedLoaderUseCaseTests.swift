//
//  FeedLoaderUseCaseTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/10.
//

import XCTest
import ToDDoCore

protocol FeedStore {
    func retrieve()
}

class FeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func load() {
        store.retrieve()
    }
}

class FeedLoaderUserCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    func test_load_requestsStoreRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> (sut: FeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = FeedLoader(store: store)
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
        var receivedMessage = [ReceivedMessage]()
        
        enum ReceivedMessage: Equatable {
            case retrieve
        }
        
        func retrieve() {
            receivedMessage.append(.retrieve)
        }
    }
    
}
