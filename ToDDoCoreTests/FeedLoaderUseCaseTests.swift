//
//  FeedLoaderUseCaseTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/10.
//

import XCTest
import ToDDoCore

struct Item {
    
}

protocol FeedStore {
    typealias RetrievalResult = (Result<Item?, Error>) -> Void
    func retrieve(completion: @escaping RetrievalResult)
}

class FeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func load(completion: @escaping FeedStore.RetrievalResult = { _ in }) {
        store.retrieve(completion: completion)
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
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        var receivedError: Error?
        sut.load { result in
            if case let .failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        let error = NSError(domain: "any error", code: 0)
        store.completeRetrieval(with: error)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, error)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = FeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
        var receivedMessage = [ReceivedMessage]()
        
        private var retrieveCompletion = [RetrievalResult]()
        
        enum ReceivedMessage: Equatable {
            case retrieve
        }
        
        func retrieve(completion: @escaping RetrievalResult) {
            receivedMessage.append(.retrieve)
            retrieveCompletion.append(completion)
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            retrieveCompletion[index](.failure(error))
        }
    }
}
