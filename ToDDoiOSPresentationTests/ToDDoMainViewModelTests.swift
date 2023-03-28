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
        let date = renderExactDate()
        let sut = ToDDoMainViewModel(date: date, lists: uniqueUser().models)
        
        XCTAssertEqual(sut.dateText, "Tuesday, Mar 28, 2023")
    }
    
    func test_init_givenDateRenderTasksCountInThatDate() {
        let date = renderExactDate()
        let sameDayDate = date.addDay(1).addMinute(-1)
        let lists = uniqueUser(date: date).models
        let sut = ToDDoMainViewModel(date: sameDayDate, lists: lists)
        
        XCTAssertEqual(sut.toDoCount, 2)
    }
    
    func test_init_givenOldDateToDoCountShouldBeZero() {
        let date = renderExactDate()
        let oldDate = date.addMinute(-1)
        let lists = uniqueUser(date: oldDate).models
        let sut = ToDDoMainViewModel(date: date, lists: lists)
        
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    //MARK: - Helpers
    /// Render date using unix timestamp
    /// - Returns: 2023-03-28 00:00:00
    func renderExactDate() -> Date {
        Date(timeIntervalSince1970: 1679932800)
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
