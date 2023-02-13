//
//  FeedLoaderUseCaseTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/10.
//

import XCTest
import ToDDoCore

protocol FeedStore {
    typealias RetrievalCompletion = (Result<FeedListGroups?, Error>) -> Void
    func retrieve(completion: @escaping RetrievalCompletion)
}

class FeedLoader {
    let store: FeedStore
    
    typealias LoadResult = Result<FeedListGroups?, Error>
    init(store: FeedStore) {
        self.store = store
    }
    
    func load(completion: @escaping (LoadResult) -> Void = { _ in }) {
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
        let anyError = NSError(domain: "any error", code: 0)
        
        expect(sut, toCompleteWith: .failure(anyError)) {
            store.completeRetrieval(with: anyError)
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = FeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem, file: file, line: line)
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
                
            default:
                XCTFail("Expected to get Result: \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
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
    }
}
