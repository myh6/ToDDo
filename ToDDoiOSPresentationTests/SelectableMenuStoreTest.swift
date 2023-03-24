//
//  SelectableMenuStoreTest.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import XCTest

struct SelectableMenuStore {
    var options: [Option]
    
    init(options: [String]) {
        self.options = options.map { Option(text: $0) }
    }
}

struct Option {
    let text: String
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected.toggle()
    }
}

class SelectableMenuStoreTest: XCTestCase {
    
    func test_selectOption_togglesState() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
}
