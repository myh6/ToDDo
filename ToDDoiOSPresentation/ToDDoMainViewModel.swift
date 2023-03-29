//
//  ToDDoMainViewModel.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/28.
//

import Foundation
import ToDDoCore

public struct ToDDoMainViewModel {
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
    let store: SelectableMenuStore
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
    
    public init(store: SelectableMenuStore, date: Date, lists: [FeedListGroup], timezone: TimeZone = .current, locale: Locale = .current) {
        self.store = store
        self.lists = lists
        self.dateInDate = date
        self.dateFormatter.timeZone = timezone
        self.dateFormatter.locale = locale
        self.calendar.timeZone = timezone
        self.calendar.locale = locale
    }
}
