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
    @Published private(set) var lists: [FeedListGroup] = []
    @Published public private(set) var hasError = false
    let loader: FeedLoader
    
    public init(options: [String], date: Date, loader: FeedLoader, timezone: TimeZone = .current, locale: Locale = .current, didSelect: @escaping (String) -> Void) {
        self.store = SelectableMenuStore(options: options, didSelect: didSelect)
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
                self?.hasError = false
            } catch {
                self?.hasError = true
            }
        }
    }
}
