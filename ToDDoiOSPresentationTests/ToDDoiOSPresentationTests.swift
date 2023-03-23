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
            let (_ ,loader) = makeSUT()
            
            XCTAssertEqual(loader.loadCallCount, 0)
        }
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }

}
