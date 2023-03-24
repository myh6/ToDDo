//
//  SelectableMenuStoreTest.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import XCTest
import ToDDoiOSPresentation

class SelectableMenuStoreTest: XCTestCase {
    
    func test_init_selectedOptionIsTheFirstOption() {
        let sut = SelectableMenuStore(options: ["A option", "B option"])
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.selectedOptionText, "A option")
        XCTAssertEqual(sut.options[0].isSelected, true)
    }
    
    func test_selectOption_togglesOptionState() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.selectOption(at: 0)
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.selectOption(at: 0)
        XCTAssertTrue(sut.options[0].isSelected)
    }
    
    func test_selectOption_changeSelectedOption() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.options[0].isSelected, true)
        
        sut.selectOption(at: 1)
        XCTAssertEqual(sut.selectedOptionIndex, 1)
        XCTAssertEqual(sut.options[0].isSelected, false)
        XCTAssertEqual(sut.options[1].isSelected, true)
        XCTAssertEqual(sut.selectedOptionText, "B option")
    }
    
    func test_selectOption_doesNothingIfIndexIsOutOfRange() {
        var sut = SelectableMenuStore(options: ["A option", "B option"])
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.selectedOptionText, "A option")
        sut.selectOption(at: 3)
        
        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.selectedOptionText, "A option")
    }
    
}
