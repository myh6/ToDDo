//
//  SelectableMenuStoreTest.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import XCTest

struct SelectableMenuStore {
    var options: [Option]
    
    var selectedOptionIndex = 0
    
    init(options: [String]) {
        self.options = options.map { Option(text: $0) }
    }
    
    mutating func selectOption(at index: Int) {
        guard options.indices.contains(index) else { return }
        options = options.enumerated().map { i, option in
            var option = option
            option.isSelected = (i == index)
            return option
        }
        selectedOptionIndex = index
    }
    
}

struct Option: Equatable {
    let text: String
    var isSelected: Bool = false
}

class SelectableMenuStoreTest: XCTestCase {
    
    func test_init_selectedOptionIsTheFirstOption() {
        let sut = SelectableMenuStore(options: ["A option", "B option"])
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
    }
    
    func test_selectOption_togglesOptionState() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.selectOption(at: 0)
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.selectOption(at: 0)
        XCTAssertTrue(sut.options[0].isSelected)
    }
    
    func test_selectOption_changeSelectedOption() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
        
        sut.selectOption(at: 1)
        XCTAssertEqual(sut.selectedOptionIndex, 1)
    }
    
    func test_selectOption_doesNothingIfIndexIsOutOfRange() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
        sut.selectOption(at: 3)
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
    }
    
}
