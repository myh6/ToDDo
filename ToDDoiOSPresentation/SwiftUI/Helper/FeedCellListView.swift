//
//  FeedCellListView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/30.
//

import SwiftUI
import ToDDoCore

struct FeedCellListView: View {
    
    @StateObject var viewModel: ToDDoMainViewModel
    var body: some View {
        List {
            ForEach(viewModel.lists, id: \.id) { list in
                Button(action: {}) {
                    FeedCellView(text: list.listTitle) {
                        // TODO: -
                        print("Unimplemented operation")
                    }
                    .frame(height: 80.0)
                    .padding(.horizontal, 10.0)
                }
            }
        }
        .listStyle(.plain)
        .onAppear { viewModel.load() }
    }
}

struct FeedCellListView_Previews: PreviewProvider {
    static var previews: some View {
        let options = ["Recent", "Pending", "Finished"]
        let viewModel = ToDDoMainViewModel(options: options, date: Date(), loader: LoaderFake(), didSelect: { _ in })
        FeedCellListView(viewModel: viewModel)
    }
    
    struct LoaderFake: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
        let lists = [FeedListGroup(id: UUID(), listTitle: "A task list", listImage: Data(), items: []),
                     FeedListGroup(id: UUID(), listTitle: "Another task list", listImage: Data(), items: [FeedToDoItem(id: UUID(), title: "A title", isDone: false, expectedDate: Date(), finishedDate: nil, priority: "high", url: nil, note: nil)]),
                     FeedListGroup(id: UUID(), listTitle: "Yet another task list", listImage: Data(), items: [FeedToDoItem(id: UUID(), title: "A title", isDone: true, expectedDate: Date(), finishedDate: nil, priority: nil, url: nil, note: nil)])]
            completion(.success(lists))
        }
    }
}
