//
//  ToDDoMainPageViewSnapshotTests.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/31.
//

import XCTest
import ToDDoCore
import ToDDoiOSPresentation
import SwiftUI

class ToDDoMainPageViewSnapshotTests: XCTestCase {
    
    func test_emptyView() {
        let sut = makeSUT(loader: LoaderFakeWithEmptyData())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_VIEW_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_VIEW_dark")
    }
    
    func test_errorView() {
        let sut = makeSUT(loader: LoaderFakeWithError())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "ERROR_VIEW_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "ERROR_VIEW_dark")
    }
    
    //MARK: - Helpers
    private func makeSUT(loader: FeedLoader, file: StaticString = #file, line: UInt = #line) -> UIHostingController<ToDDoMainPageView> {
        let store = SelectableMenuStore(options: ["Recent", "Pending", "Finished"], didSelect: { _ in})
        let viewModel = ToDDoMainViewModel(date: renderExactDate(), loader: loader, timezone: TimeZone(identifier: "UTC")!, locale: Locale(identifier: "en_US_POSIX"))
        let sut = UIHostingController(rootView: ToDDoMainPageView(viewModel: viewModel, store: store))
        return sut
    }
    
    private class LoaderFakeWithEmptyData: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completion(.success(nil))
        }
    }
    
    private class LoaderFakeWithError: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            let error = NSError(domain: "An Error", code: 0)
            completion(.failure(error))
        }
    }
}
