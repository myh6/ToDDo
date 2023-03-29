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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                FeedTitleView(title: "ToDDo", date: viewModel.dateText).padding([.top, .leading, .bottom], 20.0)
                Spacer()
            }
            FeedSquareView(width: 120, height: 120, title: "TODAY", number: viewModel.toDoCount).padding(.leading, 20.0)
            
            HorizontalMenu(store: viewModel.store).padding(.leading, 20.0)
            
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
        @State var lastSelectedMenu = "none"
        var body: some View {
            let store = SelectableMenuStore(options: ["Recent", "Pending", "Finished"], didSelect: { lastSelectedMenu = $0 })
            let viewModel = ToDDoMainViewModel(store: store, date: Date(), lists: [FeedListGroup(id: UUID(), listTitle: "A task list", listImage: Data(), items: []), FeedListGroup(id: UUID(), listTitle: "Another task list", listImage: Data(), items: []), FeedListGroup(id: UUID(), listTitle: "Yet another task list", listImage: Data(), items: [])])
            VStack {
                ToDDoMainPageView(viewModel: viewModel)
                Text("Last selected menu: " + lastSelectedMenu)
            }
        }
    }
}
