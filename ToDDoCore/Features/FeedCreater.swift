//
//  FeedCreate.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/17.
//

import Foundation

public protocol FeedCreater {
    typealias Result = Swift.Result<Void, Error>
    
    func create(_ feed: FeedListGroup, completion: @escaping (Result) -> Void)
}
