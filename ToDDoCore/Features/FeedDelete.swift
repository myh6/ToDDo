//
//  FeedDelete.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedDelete {
    typealias Result = Swift.Result<Void, Error>
    
    func delete(_ feed: FeedListGroup, completion: @escaping (FeedDelete.Result) -> Void)
}
