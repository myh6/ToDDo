//
//  ToDDoAppApp.swift
//  ToDDoApp
//
//  Created by Min-Yang Huang on 2023/3/31.
//

import SwiftUI
import ToDDoCore
import ToDDoiOSPresentation

@main
struct ToDDoAppApp: App {
    var body: some Scene {
        WindowGroup {
            
            let viewModel = ToDDoMainViewModel(date: Date(), loader: LoaderFake())
            let store = SelectableMenuStore(options: ["Recent", "Pending", "Finished"]) {
                viewModel.loadWith(MenuOption(rawValue: $0) ?? .recent)
            }
            ToDDoMainPageView(viewModel: viewModel, store: store)
        }
    }
}

class LoaderFake: FeedLoader {
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(.success(nil))
    }
}
