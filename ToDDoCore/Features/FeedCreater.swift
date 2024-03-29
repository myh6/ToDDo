//
//  FeedCreate.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedCreater {
    typealias Result = Swift.Result<Void, Error>
    
    func create(_ list: FeedListGroup, timestamp: Date, completion: @escaping (Result) -> Void)
    
    func add(_ item: FeedToDoItem, timestamp: Date, to list: FeedListGroup, completion: @escaping (Result) -> Void)
}
