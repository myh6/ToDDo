//
//  SharedTestHelpers.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/14.
//

import ToDDoCore

func makeFeedListGroups(listTitle: String = "a title", listImage: Data = Data("a image".utf8), itemsCount: Int = 0) -> FeedListGroup {
    FeedListGroup(id: UUID(), listTitle: listTitle, listImage: listImage, itemsCount: itemsCount)
}

func anyNSError() -> Error {
    NSError(domain: "any error", code: 0)
}
