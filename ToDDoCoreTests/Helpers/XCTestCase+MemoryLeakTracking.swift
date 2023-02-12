//
//  XCTestCase+MemoryLeakTracking.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/12.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocaed, Potential memory leak", file: file, line: line)
        }
    }
}
