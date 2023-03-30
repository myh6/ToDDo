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
    
    func test_init_renderCorrectFormattedDate() {
        let lists = uniqueUser().models
        let (sut, loader) = makeSUT(date: renderExactDate())
        
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.dateText, "Tuesday, Mar 28, 2023")
    }
    
    func test_init_givenDateRenderTasksCountInThatDate() {
        let date = renderExactDate()
        let sameDayDate = date.addDay(1).addMinute(-1)
        let lists = uniqueUser(date: date).models
        let (sut, loader) = makeSUT(date: sameDayDate)
        
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.toDoCount, 2)
    }
    
    func test_init_givenOldDateToDoCountShouldBeZero() {
        let date = renderExactDate()
        let oldDate = date.addMinute(-1)
        let lists = uniqueUser(date: oldDate).models
        let (sut, loader) = makeSUT(date: date)
        
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    func test_init_givenNewerDateToDoCountShouldBeZero() {
        let date = renderExactDate()
        let newDate = date.addDay(1)
        let lists = uniqueUser(date: newDate).models
        let (sut, loader) = makeSUT(date: date)
        
        loader.completeLoadWithList(lists)
        
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    //MARK: - Helpers
    private func makeSUT(date: Date = Date(), file: StaticString = #file, line: UInt = #line) -> (sut: ToDDoMainViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = ToDDoMainViewModel(options: [], date: date, loader: loader, timezone: TimeZone(identifier: "UTC")!, locale: Locale(identifier: "en_US_POSIX"), didSelect: {_ in})
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    /// Render date using unix timestamp
    /// - Returns: 2023-03-28 00:00:00
    private func renderExactDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = "2023-03-28 00:00:00"
        return dateFormatter.date(from: dateString)!
    }
    
    class LoaderSpy: FeedLoader {
        private(set) var receivedMessage = [((FeedLoader.Result) -> Void)]()
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            receivedMessage.append(completion)
        }
        
        func completeLoadWithList(_ lists: [FeedListGroup], at index: Int = 0) {
            receivedMessage[index](.success(lists))
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
