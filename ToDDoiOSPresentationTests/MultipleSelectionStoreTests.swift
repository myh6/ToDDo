//
//  MultipleSelectionStoreTests.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/27.
//

import XCTest

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    
    var canSubmit: Bool {
        !options.filter(\.isSelected).isEmpty
    }
    
    private let handler: ([String]) -> Void
    
    init(options: [String], handler: @escaping ([String]) -> Void = { _ in }) {
        self.options = options.map { MultipleSelectionOption(text: $0) }
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else { return }
        handler(options.filter(\.isSelected).map(\.text))
        
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false
    
    mutating func select() {
        isSelected.toggle()
    }
}

class MultipleSelectionStoreTests: XCTestCase {
    
    func test() {
        var sut = MultipleSelectionStore(options: ["o1", "o2"])
        XCTAssertFalse(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertTrue(sut.options[0].isSelected)
        
        sut.options[0].select()
        XCTAssertFalse(sut.options[0].isSelected)
    }
    
    func test_canSubmit_whenAtLeastOneOptionIsSelected() {
        var sut = MultipleSelectionStore(options: ["o1", "o2"])
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertTrue(sut.canSubmit)
        
        sut.options[0].select()
        XCTAssertFalse(sut.canSubmit)
        
        sut.options[1].select()
        XCTAssertTrue(sut.canSubmit)
    }
    
    func test_submit_notifiesHandlerWithSelectedOptions() {
        var submittedOptions = [[String]]()
        var sut = MultipleSelectionStore(options: ["o1", "o2"], handler: {
            submittedOptions.append($0)
        })
        
        sut.submit()
        XCTAssertEqual(submittedOptions, [])
        
        sut.options[0].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"]])
        
        sut.options[1].select()
        sut.submit()
        XCTAssertEqual(submittedOptions, [["o1"], ["o1", "o2"]])
    }
    
}
