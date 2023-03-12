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
        let combineList = combineList(list: list, item: item)

        insert(item, to: list, to: sut)
        
        expect(sut, toRetrieve: .success([combineList]))
    }
    
    func test_retrieve_deliversFoundListValueAfterInsertingItemOnNonEmptyDatabaseWithEmptyListItem() {
        let sut = makeSUT()
        let list = uniquePureList().local
        insert(list, to: sut)
        
        let item = uniqueItem().local
        let combinedList = combineList(list: list, item: item)
        
        insert(item, to: list, to: sut)
        
        expect(sut, toRetrieve: .success([combinedList]))
    }
    
    func test_retrieve_delviersFoundListValueAfterInsertingItemOnNonEmptyDatabaseWithNonEmptyListItems() {
        let sut = makeSUT()
        let list = uniqueList().local
        insert(list, to: sut)
        
        let item = uniqueItem().local
        let combinedList = combineList(list: list, item: item)
        
        insert(item, to: list, to: sut)
        
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
    
    func test_insert_sameListTwice_deliversNoRepeatedListData() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        insert(list, to: sut)
        insert(list, to: sut)
        
        expect(sut, toRetrieve: .success([list]))
    }
    
    func test_insert_item_deliversNoErrorOnEmptyDatabse() {
        let sut = makeSUT()
        let item = uniqueItem()
        let list = uniquePureList()
        
        let receivedError = insert(item.local, to: list.local, to: sut)
        XCTAssertNil(receivedError)
    }
    
    func test_insert_sameItemTwice_deliversNoRepeatedListData() {
        let sut = makeSUT()
        let item = uniqueItem().local
        let list = uniqueList().local
        
        let combinedList = combineList(list: list, item: item)
        insert(item, to: list, to: sut)
        insert(item, to: list, to: sut)
        
        expect(sut, toRetrieve: .success([combinedList]))
    }
    
    func test_remove_list_deliversNoErrorOnEmptyDatabase() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        let receivedError = remove(list, from: sut)
        
        XCTAssertNil(receivedError)
    }
    
    func test_remove_list_hasNoSideEffectOnEmptyDatabase() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        remove(list, from: sut)

        expect(sut, toRetrieve: .success([]))
    }
    
    func test_remove_list_deliversNoErrorOnNonEmptyDatabaseWithNoMatchingList() {
        let sut = makeSUT()
        let savedlist = uniqueList().local
        let deleteList = uniqueList().local
        
        insert(savedlist, to: sut)
        let receivedError = remove(deleteList, from: sut)
        
        XCTAssertNil(receivedError)
    }
    
    func test_remove_list_deletesMatchingListInDatabase() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        insert(list, to: sut)
        remove(list, from: sut)
        
        expect(sut, toRetrieve: .success([]))
    }
    
    func test_remove_item_deliversNoErrorOnEmptyDatabase() {
        let sut = makeSUT()
        let item = uniqueItem().local
        let list = uniqueList().local
        
        let receivedError = remove(item, from: list, from: sut)
        
        XCTAssertNil(receivedError)
    }
    
    func test_remove_item_hasNoSideEffectOnEmptyDatabase() {
        let sut = makeSUT()
        let item = uniqueItem().local
        let list = uniqueList().local
        
        remove(item, from: list, from: sut)
        
        expect(sut, toRetrieve: .success([]))
    }
    
    func test_remove_item_deliversNoErrorOnNonEmptyDatabaseWithNoMatchingItem() {
        let sut = makeSUT()
        let savedItem = uniqueItem().local
        let deletedItem = uniqueItem().local
        let list = uniqueList().local
        
        insert(savedItem, to: list, to: sut)
        let recievedError = remove(deletedItem, from: list, from: sut)
        
        XCTAssertNil(recievedError)
    }
    
    func test_remove_item_deletesMatchingItemInDatabase() {
        let sut = makeSUT()
        let item = uniqueItem().local
        let list = uniqueList().local
        
        insert(item, to: list, to: sut)
        expect(sut, toRetrieve: .success([combineList(list: list, item: item)]))
        remove(item, from: list, from: sut)
        
        expect(sut, toRetrieve: .success([list]))
    }
    
    func test_update_list_deliversNoErrorOnEmptyDatabase() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        let receivedError = update(list, in: sut)
        XCTAssertNil(receivedError)
    }
    
    func test_update_hasNoSideEffectOnEmptyDatabase() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        update(list, in: sut)
        
        expect(sut, toRetrieve: .success([]))
    }
    
    func test_update_list_deliversNoErrorOnNonEmptyDatabaseWithNoMatchingList() {
        let sut = makeSUT()
        let savedList = uniqueList().local
        let updateList = uniqueList().local
        
        insert(savedList, to: sut)
        let recievedError = update(updateList, in: sut)
        
        XCTAssertNil(recievedError)
    }
    
    func test_update_list_deletesMatchingListInDatabase() {
        let sut = makeSUT()
        let savedList = uniqueList().local
        
        insert(savedList, to: sut)
        expect(sut, toRetrieve: .success([savedList]))
        
        let updateList = LocalFeedListGroup(id: savedList.id, listTitle: "Updated Title", listImage: savedList.listImage, items: savedList.items)
        update(updateList, in: sut)
        
        expect(sut, toRetrieve: .success([updateList]))
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
    
    private func combineList(list: LocalFeedListGroup, item: LocalToDoItem) -> LocalFeedListGroup {
        var listItems = list.items
        listItems.append(item)
        return LocalFeedListGroup(id: list.id, listTitle: list.listTitle, listImage: list.listImage, items: listItems)
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
    
    @discardableResult
    private func insert(_ item: LocalToDoItem, to list: LocalFeedListGroup, to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for insertion")
        var insertionError: Error?
        
        sut.insert(item, to: list) { result in
            if case let Result.failure(error) = result {
                insertionError = error
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    private func remove(_ list: LocalFeedListGroup, from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for remove completion")
        var receiverError: Error?
        sut.remove(list) { result in
            if case let Result.failure(error) = result {
                receiverError = error
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receiverError
    }
    
    @discardableResult
    private func remove(_ item: LocalToDoItem, from list: LocalFeedListGroup, from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for remove completion")
        var receiverError: Error?
        sut.remove(item, from: list) { result in
            if case let Result.failure(error) = result {
                receiverError = error
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receiverError
    }
    
    @discardableResult
    private func update(_ list: LocalFeedListGroup, in sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for update complete")
        var receivedError: Error?
        sut.update(list) { result in
            if case let Result.failure(error) = result {
                receivedError = error
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
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
