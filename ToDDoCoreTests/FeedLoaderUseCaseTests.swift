//
//  FeedLoaderUseCaseTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/10.
//

import XCTest
import ToDDoCore

class FeedLoader {
    
}

class FeedLoaderUserCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> (sut: FeedLoader, store: FeedStoreSpy) {
        let sut = FeedLoader()
        let store = FeedStoreSpy()
        return (sut, store)
    }
    
    private class FeedStoreSpy {
        let receivedMessage = [ReceivedMessage]()
        
        enum ReceivedMessage: Equatable {}
    }
    
}
