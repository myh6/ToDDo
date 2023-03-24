//
//  SelectableMenuStoreTest.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import XCTest

struct SelectableMenuStore {
    var options: [Option]
    
    var selectedOption: Option {
        options.filter({ $0.isSelected }).first ?? options[0]
    }
    
    init(options: [String]) {
        self.options = options.map { Option(text: $0) }
    }
    
}

struct Option: Equatable {
    let text: String
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected.toggle()
    }
}

class SelectableMenuStoreTest: XCTestCase {
    
    func test_init_selectedOptionIsTheFirstOption() {
        let sut = SelectableMenuStore(options: ["A option", "B option"])
        
        XCTAssertEqual(sut.selectedOption, sut.options[0])
    }
    
    func test_selectOption_togglesState() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
}
