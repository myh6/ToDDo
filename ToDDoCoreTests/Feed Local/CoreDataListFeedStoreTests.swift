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
        
        expect(sut, toRetrieve: .success([]))
    }
    
    func test_retrieve_hasNoSideEffectOnEmptyDatabase() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .success([]))
        expect(sut, toRetrieve: .success([]))
    }
    
    func test_retrieve_deliversFoundPureListValueOnNonEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        
        insert(list, to: sut)
        
        expect(sut, toRetrieve: .success([list]))
    }
    
    func test_retrieve_deliversFoundListValueOnNonEmptyDatabase() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        insert(list, to: sut)
        
        expect(sut, toRetrieve: .success([list]))
    }
    
    func test_retrieve_deliversFoundListValueAfterInsertingItemOnEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        let item = uniqueItem().local
        let combineList = LocalFeedListGroup(id: list.id, listTitle: list.listTitle, listImage: list.listImage, items: [item])
        let exp = expectation(description: "Wait for insert complete")
        
        sut.insert(item, to: list) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to insert successfully, got \(error) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        expect(sut, toRetrieve: .success([combineList]))
    }
    
    func test_retrieve_deliversFoundListValueAfterInsertingItemOnNonEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        insert(list, to: sut)
        
        let exp = expectation(description: "Wait for insert complete")
        let item = uniqueItem().local
        let combinedList = LocalFeedListGroup(id: list.id, listTitle: list.listTitle, listImage: list.listImage, items: [item])
        sut.insert(item, to: list) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to insert successfully, got \(error) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        expect(sut, toRetrieve: .success([combinedList]))
    }
    
    func test_retrieve_hasNoSideEffectOnNonEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        
        insert(list, to: sut)
        
        expect(sut, toRetrieve: .success([list]))
        expect(sut, toRetrieve: .success([list]))
    }
    
    func test_insert_list_deliversNoErrorOnEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        
        let receivedError = insert(list, to: sut)
        XCTAssertNil(receivedError)
    }
    
    func test_insert_list_deliversNoErrorOnNonEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        
        insert(list, to: sut)
        
        let receivedError = insert(uniquePureList().local, to: sut)
        XCTAssertNil(receivedError)
    }
    
    func test_insert_item_deliversNoErrorOnEmptyDatabse() {
        let sut = makeSUT()
        let item = uniqueItem()
        let list = uniquePureList()
        
        var receivedError: Error?
        let exp = expectation(description: "Wait for insert complete")
        sut.insert(item.local, to: list.local) { result in
            if case let Result.failure(error) = result {
                receivedError = error
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNil(receivedError)
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
    
    private func expect(_ sut: FeedStore, toRetrieve expectedResult: Result<[LocalFeedListGroup], Error>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieve complete")
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case let (.success(expected), .success(retireved)):
                XCTAssertEqual(expected, retireved, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
