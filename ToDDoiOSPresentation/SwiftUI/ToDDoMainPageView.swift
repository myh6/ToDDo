//
//  ToDDoMainPageView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import SwiftUI
import ToDDoCore

struct ToDDoMainPageView: View {
    @StateObject var viewModel: ToDDoMainViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                FeedTitleView(title: "ToDDo", date: viewModel.dateText).padding([.top, .leading], 20.0)
                Spacer()
            }
            
            if viewModel.hasError {
                ErrorView(message: "Error! Please Retry") {
                    viewModel.load()
                }
                .frame(height: 40)
                .padding([.bottom], 5)
            }
            
            FeedSquareView(width: 120, height: 120, title: "TODAY", number: viewModel.toDoCount).padding(.leading, 20.0)
            
            HorizontalMenu(store: viewModel.store).padding(.leading, 20.0)
            
            
            List {
                ForEach(viewModel.lists, id: \.id) { list in
                    Button(action: {}) {
                        FeedCellView(text: list.listTitle) {
                            print("Unimplemented operation")
                        }
                        .frame(height: 80.0)
                        .padding(.horizontal, 10.0)
                    }
                }
            }
            .listStyle(.plain)
            .onAppear { viewModel.load() }
            
            Spacer()
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
            let viewModel = ToDDoMainViewModel(options: options, date: Date(), loader: loader, didSelect: {
                lastSelectedMenu = $0
            })
            VStack {
                ToDDoMainPageView(viewModel: viewModel)
                Text("Last selected menu: " + lastSelectedMenu)
            }
        }
    }
    
    struct LoaderFake: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
        let lists = [FeedListGroup(id: UUID(), listTitle: "A task list", listImage: Data(), items: []), FeedListGroup(id: UUID(), listTitle: "Another task list", listImage: Data(), items: [FeedToDoItem(id: UUID(), title: "A title", isDone: false, expectedDate: Date(), finishedDate: nil, priority: "high", url: nil, note: nil)]), FeedListGroup(id: UUID(), listTitle: "Yet another task list", listImage: Data(), items: [FeedToDoItem(id: UUID(), title: "A title", isDone: true, expectedDate: Date(), finishedDate: nil, priority: nil, url: nil, note: nil)])]
            completion(.success(lists))
        }
    }
    
    struct LoaderFailedFake: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completion(.failure(NSError(domain: "An error", code: 0)))
        }
    }
}
