//
//  ToDDoMainViewModel.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import Foundation
import ToDDoCore

public class ToDDoMainViewModel: ObservableObject {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    private var calendar: Calendar = {
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
    @Published public private(set) var lists: [FeedListGroup] = []
    @Published public private(set) var errorStatus: (hasError: Bool, errorText: String) = (false, "")
    let loader: FeedLoader
    
    private var allLists: [FeedListGroup] = []
    
    public init(options: [String], date: Date, loader: FeedLoader, timezone: TimeZone = .current, locale: Locale = .current) {
        self.dateInDate = date
        self.dateFormatter.timeZone = timezone
        self.dateFormatter.locale = locale
        self.calendar.timeZone = timezone
        self.calendar.locale = locale
        self.loader = loader
    }
}


public extension ToDDoMainViewModel {
    
    func load() {
        loader.load { [weak self] result in
            do {
                self?.lists = try result.get() ?? []
                self?.allLists = try result.get() ?? []
                self?.errorStatus = (false, "")
            } catch {
                self?.errorStatus = (true, error.localizedDescription)
            }
        }
    }
    
    func loadWith(_ option: MenuOption) {
        switch option {
        case .recent:
            lists = allLists
        case .pending:
            lists = filterItems(allLists, isDone: false)
        case .finished:
            lists = filterItems(allLists, isDone: true)
        }
    }
}

// MARK: Helpers
extension ToDDoMainViewModel {
    private func filterItems(_ allLists: [FeedListGroup], isDone: Bool) -> [FeedListGroup]{
        allLists.map { list in
            let filtered = list.items.filter{ $0.isDone == isDone }
            return FeedListGroup(id: list.id, listTitle: list.listTitle, listImage: list.listImage, items: filtered)
        }
    }
}

public enum MenuOption: String {
    case recent = "Recent", pending = "Pending", finished = "Finished"
}
