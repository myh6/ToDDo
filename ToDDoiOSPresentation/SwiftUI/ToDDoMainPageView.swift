//
//  ToDDoMainPageView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import SwiftUI
import ToDDoCore

struct ToDDoMainPageView: View {
    let viewModel: ToDDoMainViewModel
    let store: SelectableMenuStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                FeedTitleView(title: "ToDDo", date: viewModel.dateText).padding([.top, .leading, .bottom], 20.0)
                Spacer()
            }
            FeedSquareView(width: 120, height: 120, title: "TODAY", number: viewModel.toDoCount).padding(.leading, 20.0)
            
            HorizontalMenu(store: store).padding(.leading, 20.0)
            
            ForEach(viewModel.lists, id: \.id) { list in
                FeedCellView(text: list.listTitle) {
                    print("Unimplemented operation")
                }
                .frame(height: 80.0)
                .padding(.horizontal, 10.0)
            }
            
            Spacer()
        }
        
    }
}

struct ToDDoMainPageView_Previews: PreviewProvider {
    
    static var previews: some View {
        ToDDoMainTestView()
    }
    
    struct ToDDoMainTestView: View {
        var body: some View {
            let viewModel = ToDDoMainViewModel(date: Date(), lists: [FeedListGroup(id: UUID(), listTitle: "A task list", listImage: Data(), items: []), FeedListGroup(id: UUID(), listTitle: "Another task list", listImage: Data(), items: [])])
            let store = SelectableMenuStore(options: ["Recent", "Pending", "Finished"], didSelect: { _ in})
            ToDDoMainPageView(viewModel: viewModel, store: store)
        }
    }
}
