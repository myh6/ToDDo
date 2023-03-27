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
        let sut = makeSUT(options: ["A option", "B option"])

        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.selectedOptionText, "A option")
        XCTAssertEqual(sut.options[0].isSelected, true)
    }

    func test_selectOption_togglesOptionState() {
        let sut = makeSUT(options: ["A option", "B option"])
        XCTAssertTrue(sut.options[0].isSelected)

        sut.selectOption(at: 0)
        XCTAssertTrue(sut.options[0].isSelected)

        sut.selectOption(at: 0)
        XCTAssertTrue(sut.options[0].isSelected)
    }

    func test_selectOption_changeSelectedOption() {
        let sut = makeSUT(options: ["A option", "B option"])

        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.options[0].isSelected, true)

        sut.selectOption(at: 1)
        XCTAssertEqual(sut.selectedOptionIndex, 1)
        XCTAssertEqual(sut.options[0].isSelected, false)
        XCTAssertEqual(sut.options[1].isSelected, true)
        XCTAssertEqual(sut.selectedOptionText, "B option")
    }

    func test_selectOption_doesNothingIfIndexIsOutOfRange() {
        let sut = makeSUT(options: ["A option", "B option"])

        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.selectedOptionText, "A option")
        sut.selectOption(at: 3)

        XCTAssertEqual(sut.selectedOptionIndex, 0)
        XCTAssertEqual(sut.selectedOptionText, "A option")
    }

    func test_selectOption_triggeredHandler() {
        var triggeredHandler = [String]()
        let sut = makeSUT(options: ["A option", "B option"]) {
            triggeredHandler.append($0)
        }

        XCTAssertEqual(triggeredHandler, ["A option"])

        sut.selectOption(at: 0)
        XCTAssertEqual(triggeredHandler, ["A option", "A option"])

        sut.selectOption(at: 1)
        XCTAssertEqual(triggeredHandler, ["A option", "A option", "B option"])
    }

    //MARK: - Helpers
    private func makeSUT(options: [String], didSelect: @escaping (String) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> SelectableMenuStore {
        let sut = SelectableMenuStore(options: options, didSelect: didSelect)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
}
