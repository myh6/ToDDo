//
//  ToDDoMainPageView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import SwiftUI
import ToDDoCore

public struct ToDDoMainPageView: View {
    @StateObject var viewModel: ToDDoMainViewModel
    @StateObject var store: SelectableMenuStore
    
    public init(viewModel: ToDDoMainViewModel, store: SelectableMenuStore) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._store = StateObject(wrappedValue: store)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                FeedTitleView(title: "ToDDo", date: viewModel.dateText).padding([.top, .leading], 20.0)
                Spacer()
            }
            
            hasError(viewModel.errorStatus.hasError, show: viewModel.errorStatus.errorText)
            
            FeedSquareView(width: 120, height: 120, title: "TODAY", number: viewModel.toDoCount).padding(.leading, 20.0)
            
            HorizontalMenu(store: store).padding(.leading, 20.0)
            
            FeedCellListView(viewModel: viewModel)
            
            Spacer()
        }.onAppear { viewModel.load() }
    }
}

extension ToDDoMainPageView {
    @ViewBuilder
    func hasError(_ value: Bool, show message: String) -> some View {
        if value {
            ErrorView(message: message) {
                viewModel.load()
            }
            .frame(height: 40)
            .padding([.bottom], 5)
        }
    }
}

struct ToDDoMainPageView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ToDDoMainTestView(loader: LoaderFake())
            ToDDoMainTestView(loader: LoaderFailedFake())
        }
    }
    
    struct ToDDoMainTestView: View {
        @State var lastSelectedMenu = "none"
        let loader: FeedLoader
        
        var body: some View {
            let options = ["Recent", "Pending", "Finished"]
            let viewModel = ToDDoMainViewModel(date: Date(), loader: loader)
            let store = SelectableMenuStore(options: options, didSelect: {
                lastSelectedMenu = $0
                viewModel.loadWith(MenuOption(rawValue: $0) ?? .recent)
            })
            VStack {
                ToDDoMainPageView(viewModel: viewModel, store: store)
                Text("Last selected menu: " + lastSelectedMenu)
            }
        }
    }
    
    struct LoaderFake: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
        let lists = [
            FeedListGroup(id: UUID(), listTitle: "A task list", listImage: Data(), items: [
                FeedToDoItem(id: UUID(), title: "A title", isDone: true, expectedDate: Date(), finishedDate: nil, priority: nil, url: nil, note: nil)]),
            FeedListGroup(id: UUID(), listTitle: "Another task list", listImage: Data(), items: [
                FeedToDoItem(id: UUID(), title: "A title", isDone: false, expectedDate: Date(), finishedDate: nil, priority: "high", url: nil, note: nil)]),
            FeedListGroup(id: UUID(), listTitle: "Yet another task list", listImage: Data(), items: [
                FeedToDoItem(id: UUID(), title: "A title", isDone: false, expectedDate: Date(), finishedDate: nil, priority: nil, url: nil, note: nil)])]
            completion(.success(lists))
        }
    }
    
    struct LoaderFailedFake: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completion(.failure(NSError(domain: "An error", code: 0)))
        }
    }
}
