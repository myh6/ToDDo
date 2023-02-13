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
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = FeedLoader(store: store)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
        var receivedMessage = [ReceivedMessage]()
        
        private var retrieveCompletion = [RetrievalCompletion]()
        
        enum ReceivedMessage: Equatable {
            case retrieve
        }
        
        func retrieve(completion: @escaping RetrievalCompletion) {
            receivedMessage.append(.retrieve)
            retrieveCompletion.append(completion)
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrieveCompletion[index](.failure(error))
        }
        
        func completeRetrieval(with item: [FeedListGroup], at index: Int = 0) {
            retrieveCompletion[index](.success(item))
        }
        
        func completeRetrievalWithEmptyDatabase(at index: Int = 0) {
            retrieveCompletion[index](.success(.none))
        }
    }
}
