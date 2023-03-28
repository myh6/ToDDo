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
