//
//  FeedStore.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/13.
//

import Foundation

public protocol FeedStore {
    typealias RetrievalCompletion = (Result<[FeedListGroup]?, Error>) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion)
}
