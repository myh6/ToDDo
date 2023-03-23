//
//  ToDDoiOSPresentationTests.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/23.
//

import XCTest
import ToDDoiOSPresentation

final class FeedViewController {
    
    init(loader: ToDDoiOSPresentationTests.LoaderSpy) {
        
    }
}

final class ToDDoiOSPresentationTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        func test_init_doesNotLoadFeed() {
            let loader = LoaderSpy()
            _ = FeedViewController(loader: loader)
            
            XCTAssertEqual(loader.loadCallCount, 0)
        }
    }
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }

}
