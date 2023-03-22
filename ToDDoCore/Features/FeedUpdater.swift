//
//  FeedUpdate.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedUpdater {
    typealias Result = Swift.Result<Void, Error>
    
    func update(_ list: FeedListGroup, timestamp: Date, completion: @escaping (FeedUpdater.Result) -> Void)
    
    func update(_ item: FeedToDoItem, timestamp: Date, completion: @escaping (FeedUpdater.Result) -> Void)
}
