//
//  FeedDeletePolicy.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/16.
//

import Foundation

final class FeedMatchingPolicy {
    private init() {}
    static func hasData(_ data: LocalFeedListGroup, in database: [LocalFeedListGroup]) -> Bool {
        database.contains(data)
    }
}
