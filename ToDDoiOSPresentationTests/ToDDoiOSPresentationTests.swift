//
//  ToDDoiOSPresentationTests.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/23.
//

import XCTest
import ToDDoiOSPresentation
import UIKit

final class FeedViewController: UIViewController {
    
    private var loader: ToDDoiOSPresentationTests.LoaderSpy?
    
    convenience init(loader: ToDDoiOSPresentationTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load()
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
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }

}
