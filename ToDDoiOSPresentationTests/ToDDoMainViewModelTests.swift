//
//  ToDDoMainViewModelTests.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import XCTest
import ToDDoiOSPresentation
import ToDDoCore

class ToDDoMainViewModelTests: XCTestCase {
    
    func test_init_doesNotRequestFeedFromLoaderUponCreation() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.receivedMessage.isEmpty)
    }
    
    func test_init_renderCorrectFormattedDate() {
        let lists = uniqueUser().models
        let (sut, loader) = makeSUT(date: renderExactDate())
        
        sut.load()
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.dateText, "Tuesday, Mar 28, 2023")
    }
    
    func test_init_givenDateRenderTasksCountInThatDate() {
        let date = renderExactDate()
        let sameDayDate = date.addDay(1).addMinute(-1)
        let lists = uniqueUser(date: date).models
        let (sut, loader) = makeSUT(date: sameDayDate)
        
        sut.load()
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.toDoCount, 2)
    }
    
    func test_init_givenOldDateToDoCountShouldBeZero() {
        let date = renderExactDate()
        let oldDate = date.addMinute(-1)
        let lists = uniqueUser(date: oldDate).models
        let (sut, loader) = makeSUT(date: date)
        
        sut.load()
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    func test_init_givenNewerDateToDoCountShouldBeZero() {
        let date = renderExactDate()
        let newDate = date.addDay(1)
        let lists = uniqueUser(date: newDate).models
        let (sut, loader) = makeSUT(date: date)
        
        sut.load()
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    func test_load_reqeustFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.receivedMessage.count, 0)
        
        sut.load()
        XCTAssertEqual(loader.receivedMessage.count, 1)
    }
    
    func test_load_changeHasErrorToTrueIfLoadOperationFailed() {
        let (sut, loader) = makeSUT()
        let error = NSError(domain: "An error", code: 0)
        XCTAssertEqual(sut.errorStatus.hasError, false)
        
        sut.load()
        loader.completeLoadWith(error)
        
        XCTAssertEqual(sut.errorStatus.hasError, true)
    }
    
    func test_load_delviersListsFromSuccessfulLoad() {
        let (sut, loader) = makeSUT()
        let lists = uniqueUser().models
        
        sut.load()
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.lists, lists)
    }
    
    func test_loadWithOption_whenGivenOptionPendingDeliversUnfinishedItem() {
        let (sut, loader) = makeSUT()
        let items = [uniqueItem(isDone: true).model, uniqueItem(isDone: false).model, uniqueItem(isDone: false).model, uniqueItem(isDone: true).model, uniqueItem(isDone: true).model]
        let list = uniqueList(uniqueItems: items).model
        
        sut.load()
        loader.completeLoadWithList([list])
        
        XCTAssertEqual(sut.lists, [list])
        
        sut.loadWith(.pending)
        XCTAssertEqual(sut.lists[0].items.count, 2)
    }
    
    func test_loadWithOption_whenGivenOptionRecentDelviersAllData() {
        let (sut, loader) = makeSUT()
        let items = [uniqueItem(isDone: true).model, uniqueItem(isDone: false).model, uniqueItem(isDone: false).model, uniqueItem(isDone: true).model]
        let list = uniqueList(uniqueItems: items).model
        
        sut.load()
        loader.completeLoadWithList([list])
        
        XCTAssertEqual(sut.lists, [list])
        
        sut.loadWith(.pending)
        XCTAssertEqual(sut.lists[0].items.count, 2)
        
        sut.loadWith(.recent)
        XCTAssertEqual(sut.lists, [list])
    }
    
    func test_loadWithOption_whenGivenOptionFinishedDeliversFinishedItem() {
        let (sut, loader) = makeSUT()
        let items = [uniqueItem(isDone: true).model, uniqueItem(isDone: false).model, uniqueItem(isDone: false).model, uniqueItem(isDone: true).model, uniqueItem(isDone: true).model]
        let list = uniqueList(uniqueItems: items).model
        
        sut.load()
        loader.completeLoadWithList([list])
        
        XCTAssertEqual(sut.lists, [list])
        
        sut.loadWith(.finished)
        XCTAssertEqual(sut.lists[0].items.count, 3)
    }
    
    //MARK: - Helpers
    private func makeSUT(date: Date = Date(), file: StaticString = #file, line: UInt = #line) -> (sut: ToDDoMainViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = ToDDoMainViewModel(date: date, loader: loader, timezone: TimeZone(identifier: "UTC")!, locale: Locale(identifier: "en_US_POSIX"))
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private(set) var receivedMessage = [((FeedLoader.Result) -> Void)]()
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            receivedMessage.append(completion)
        }
        
        func completeLoadWithList(_ lists: [FeedListGroup], at index: Int = 0) {
            receivedMessage[index](.success(lists))
        }
        
        func completeLoadWith(_ error: Error, at index: Int = 0) {
            receivedMessage[index](.failure(error))
        }
        
    }

    
}

private extension Date {
    func addDay(_ value: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .day, value: value, to: self)!
    }
    
    func addMinute(_ value: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .minute, value: value, to: self)!
    }
}
