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
    private let calendar: Calendar = {
        let calendar = Calendar(identifier: .gregorian)
        return calendar
    }()
    
    private let dateInDate: Date
    
    public var dateText: String {
        dateFormatter.string(from: dateInDate)
    }
    
    public var toDoCount: Int {
        lists.filter{
            $0.items.contains{
                guard let expectedDate = $0.expectedDate else { return false }
                return calendar.dateComponents([.year, .month, .day], from: expectedDate) == calendar.dateComponents([.year, .month, .day], from: dateInDate)
            }
        }.count
    }
    let lists: [FeedListGroup]
    
    public init(date: Date, lists: [FeedListGroup]) {
        self.lists = lists
        self.dateInDate = date
    }
}

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
