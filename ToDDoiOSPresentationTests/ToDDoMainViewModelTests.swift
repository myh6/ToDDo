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
        let date = Date(timeIntervalSince1970: 1679983658)
        let sut = ToDDoMainViewModel(date: date, lists: uniqueUser().models)
        
        XCTAssertEqual(sut.dateText, "Tuesday, Mar 28, 2023")
    }
    
}
