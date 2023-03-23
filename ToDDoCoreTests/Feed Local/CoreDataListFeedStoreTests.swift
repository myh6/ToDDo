//
//  CoreDataFeedStoreTests.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import XCTest
import ToDDoCore

class CoreDataListFeedStoreTests: XCTestCase {
    
    //MARK: - Retrieve
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
        let now = Date()
        
        insert(list, to: sut, timestamp: now)
        
        let item = uniqueItem().local
        let combinedList = combineList(list: list, item: item)
        
        insert(item, timestamp: tenSecondSince(now), to: list, to: sut)
        
        expect(sut, toRetrieve: .success([combinedList]))
    }
    
    func test_retrieve_deliversFoundListValueWithCorrectOrderAfterInsertingMoreThanOneListsToDatabase() {
        let sut = makeSUT()
        let list1 = uniqueList().local
        let list2 = uniqueList().local
        let now = now()
        
        insert(list1, to: sut, timestamp: now)
        insert(list2, to: sut, timestamp: tenSecondSince(now))
        
        expect(sut, toRetrieve: .success([list1, list2]))
    }
    
    func test_retrieve_hasNoSideEffectOnNonEmptyDatabase() {
        let sut = makeSUT()
        let list = uniquePureList().local
        
        insert(list, to: sut)
        
        expect(sut, toRetrieve: .success([list]))
        expect(sut, toRetrieve: .success([list]))
    }
    
    //MARK: - Insert
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
        
        let receivedError = insert(item.local, to: list.local, to: sut)
        XCTAssertNil(receivedError)
    }
    
    //MARK: - Remove
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
    
    func test_remove_item_updatesMatchingItemInDatabase() {
        let sut = makeSUT()
        let item = uniqueItem().local
        let list = uniqueList().local
        
        insert(item, to: list, to: sut)
        expect(sut, toRetrieve: .success([combineList(list: list, item: item)]))
        remove(item, from: list, from: sut)
        
        expect(sut, toRetrieve: .success([list]))
    }
    
    //MARK: - Update
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
    
    func test_update_list_updatesMatchingListInDatabase() {
        let sut = makeSUT()
        let savedList = uniqueList().local
        let now = now()
        
        insert(savedList, to: sut, timestamp: now)
        expect(sut, toRetrieve: .success([savedList]))
        
        let updateList = LocalFeedListGroup(id: savedList.id, listTitle: "Updated Title", listImage: savedList.listImage, items: savedList.items)
        update(updateList, timestamp: tenSecondSince(now), in: sut)
        
        expect(sut, toRetrieve: .success([updateList]))
    }
    
    func test_update_item_updatesMatchingItemInDatabase() {
        let sut = makeSUT()
        let savedItem = uniqueItem().local
        let list = uniqueList().local
        let savedList = combineList(list: list, item: savedItem)
        let now = now()
        
        insert(list, to: sut, timestamp: now)
        insert(savedItem, timestamp: tenSecondSince(now), to: list, to: sut)
        expect(sut, toRetrieve: .success([savedList]))
        
        let updateItem = LocalToDoItem(id: savedItem.id, title: "Update Title", isDone: true, expectedDate: Date(), finishedDate: Date(), priority: "Update Priority", url: URL(string: "https://update-url.com"), note: "update note")
        let updateList = combineList(list: list, item: updateItem)
        
        update(updateItem, in: sut, timestamp: twentySecondsSince(now))
        expect(sut, toRetrieve: .success([updateList]))
    }
    
    //MARK: - HasItem
    func test_hasItem_returnsTrueWithSavedList() {
        let sut = makeSUT()
        let saveList = uniqueList().local
        
        XCTAssertFalse(sut.hasItem(with: saveList.id))
        
        insert(saveList, to: sut)
        expect(sut, toRetrieve: .success([saveList]))
        
        XCTAssertTrue(sut.hasItem(with: saveList.id))
    }
    
    func test_hasItem_returnsTrueWithSavedItem() {
        let sut = makeSUT()
        let saveItem = uniqueItem().local
        let saveList = uniqueList().local
        
        XCTAssertFalse(sut.hasItem(with: saveItem.id))
        
        insert(saveItem, timestamp: Date(), to: saveList, to: sut)
        expect(sut, toRetrieve: .success([combineList(list: saveList, item: saveItem)]))
        
        XCTAssertTrue(sut.hasItem(with: saveItem.id))
    }
    
    func test_storeSideEffectsRunSerially() {
        let sut = makeSUT()
        let list = uniqueList().local
        
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(list, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.update(list, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.retrieve { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        let op4 = expectation(description: "Operation 4")
        sut.remove(list) { _ in
            completedOperationsInOrder.append(op4)
            op4.fulfill()
        }
        
        wait(for: [op1, op2, op3, op4], timeout: 5.0)
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3, op4], "Expected side-effect to run serially but operations finnished in the wrong order")
    }
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(contianer: NSPersistentContainer.load(modelName: "ToDDoStore", url: storeURL, in: storeBundle))
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func now() -> Date {
        Date()
    }
    
    private func tenSecondSince(_ date: Date) -> Date {
        date.addingTimeInterval(10.0)
    }
    
    private func twentySecondsSince(_ date: Date) -> Date {
        date.addingTimeInterval(10.0)
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
    private func insert(_ list: LocalFeedListGroup, to sut: FeedStore, timestamp: Date = Date()) -> Error? {
        let exp = expectation(description: "Wait for insertion")
        var insertionError: Error?
        sut.insert(list, timestamp: timestamp) { result in
            if case let Result.failure(error) = result {
                insertionError = error
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    private func insert(_ item: LocalToDoItem, timestamp: Date = Date(), to list: LocalFeedListGroup, to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for insertion")
        var insertionError: Error?
        
        sut.insert(item, timestamp: timestamp, to: list) { result in
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
    private func update(_ list: LocalFeedListGroup, timestamp: Date = Date(), in sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for update complete")
        var receivedError: Error?
        sut.update(list, timestamp: timestamp) { result in
            if case let Result.failure(error) = result {
                receivedError = error
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    @discardableResult
    private func update(_ item: LocalToDoItem, in sut: FeedStore, timestamp: Date) -> Error? {
        let exp = expectation(description: "Wait for update complete")
        var receivedError: Error?
        sut.update(item, timestamp: timestamp) { result in
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
