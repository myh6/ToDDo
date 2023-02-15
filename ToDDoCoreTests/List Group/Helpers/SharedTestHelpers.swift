//
//  SharedTestHelpers.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/14.
//

import ToDDoCore

func uniqueFeedListGroup(listTitle: String = "a title", listImage: Data = Data("a image".utf8), itemsCount: Int = 0) -> FeedListGroup {
    FeedListGroup(id: UUID(), listTitle: listTitle, listImage: listImage, itemsCount: itemsCount)
}

func uniqueItems() -> (models: [FeedListGroup], locals: [LocalFeedListGroup]) {
    let models = [uniqueFeedListGroup(), uniqueFeedListGroup()]
    let local = models.map { LocalFeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, itemsCount: $0.itemsCount) }
    return (models, local)
}

func uniqueItem() -> (model: FeedListGroup, local: LocalFeedListGroup) {
    let model = uniqueFeedListGroup()
    let local = LocalFeedListGroup(id: model.id, listTitle: model.listTitle, listImage: model.listImage, itemsCount: model.itemsCount)
    return (model, local)
}

func anyNSError() -> Error {
    NSError(domain: "any error", code: 0)
}
