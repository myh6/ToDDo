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
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_VIEW_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_VIEW_dark")
    }
    
    //MARK: - Helpers
    private func makeSUT() -> UIHostingController<ToDDoMainPageView> {
        let store = SelectableMenuStore(options: ["Recent", "Pending", "Finished"], didSelect: { _ in})
        let viewModel = ToDDoMainViewModel(date: renderExactDate(), loader: LoaderFake(), timezone: TimeZone(identifier: "UTC")!, locale: Locale(identifier: "en_US_POSIX"))
        let sut = UIHostingController(rootView: ToDDoMainPageView(viewModel: viewModel, store: store))
        return sut
    }
    
    /// Render date using unix timestamp
    /// - Returns: 2023-03-28 00:00:00
    private func renderExactDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = "2023-03-28 00:00:00"
        return dateFormatter.date(from: dateString)!
    }
    
    private class LoaderFake: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completion(.success(nil))
        }
    }
}
