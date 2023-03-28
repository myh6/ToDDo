//
//  ToDDoMainPageView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import SwiftUI
import ToDDoCore

public struct ToDDoMainViewModel {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public var date: String
    
    var todayNumber: Int {
        lists.filter{ $0.items.contains{ $0.expectedDate == Date() } }.count
    }
    let lists: [FeedListGroup]
    
    public init(date: Date, lists: [FeedListGroup]) {
        self.lists = lists
        self.date = dateFormatter.string(from: date)
    }
}

struct ToDDoMainPageView: View {
    let viewModel: ToDDoMainViewModel
    let store: SelectableMenuStore
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                FeedTitleView(title: "ToDDo", date: viewModel.date).padding([.top, .leading, .bottom], 20.0)
                Spacer()
            }
            FeedSquareView(width: 120, height: 120, title: "TODAY", number: viewModel.todayNumber).padding(.leading, 20.0)
            
            HorizontalMenu(store: store).padding(.leading, 20.0)
            
            ForEach(viewModel.lists, id: \.id) { list in
                FeedCellView(text: list.listTitle, priority: .none) {
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
