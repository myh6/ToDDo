//
//  SharedTestHelpers.swift
//  ToDDoCoreTests
//
//  Created by Min-Yang Huang on 2023/2/14.
//

import ToDDoCore

func uniqueFeedListGroup(listTitle: String = "a title", listImage: Data = Data("a image".utf8), items: [FeedToDoItem]) -> FeedListGroup {
    FeedListGroup(id: UUID(), listTitle: listTitle, listImage: listImage, items: items)
}

func uniqueUser() -> (models: [FeedListGroup], locals: [LocalFeedListGroup]) {
    let item1 = [uniqueItem().model]
    let item2 = [uniqueItem().model]
    let models = [uniqueFeedListGroup(items: item1), uniqueFeedListGroup(items: item2)]
    let local = models.map { LocalFeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, items: $0.items.toCoreModel()) }
    return (models, local)
}

func uniqueList() -> (model: FeedListGroup, local: LocalFeedListGroup) {
    let items = [uniqueItem().model]
    let model = uniqueFeedListGroup(items: items)
    let local = LocalFeedListGroup(id: model.id, listTitle: model.listTitle, listImage: model.listImage, items: items.toCoreModel())
    return (model, local)
}

func uniqueItem() -> (model: FeedToDoItem, local: LocalToDoItem) {
    let model = FeedToDoItem(id: UUID(), title: "a title", isDone: false, expectedDate: nil, finishedDate: nil, priority: nil, url: nil, note: nil)
    let local = LocalToDoItem(id: model.id, title: model.title, isDone: model.isDone, expectedDate: model.expectedDate, finishedDate: model.finishedDate, priority: model.priority, url: model.url, note: model.note)
    return (model, local)
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
