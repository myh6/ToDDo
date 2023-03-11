//
//  FeedUpdate.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedUpdater {
    typealias Result = Swift.Result<Void, Error>
    
    func update(_ list: FeedListGroup, completion: @escaping (FeedUpdater.Result) -> Void)
}
