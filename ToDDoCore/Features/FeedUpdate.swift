//
//  FeedUpdate.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedUpdate {
    typealias Result = Swift.Result<Void, Error>
    
    func update(_ feed: FeedListGroup, completion: @escaping (FeedUpdate.Result) -> Void)
}
