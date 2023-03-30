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

func uniqueUser(date: Date? = nil) -> (models: [FeedListGroup], locals: [LocalFeedListGroup]) {
    let item1 = [uniqueItem(date: date).model]
    let item2 = [uniqueItem(date: date).model]
    let models = [uniqueFeedListGroup(items: item1), uniqueFeedListGroup(items: item2)]
    let local = models.map { LocalFeedListGroup(id: $0.id, listTitle: $0.listTitle, listImage: $0.listImage, items: $0.items.toCoreModel()) }
    return (models, local)
}

func uniqueList(uniqueItems: [FeedToDoItem] = [uniqueItem().model]) -> (model: FeedListGroup, local: LocalFeedListGroup) {
    let model = uniqueFeedListGroup(items: uniqueItems)
    let local = LocalFeedListGroup(id: model.id, listTitle: model.listTitle, listImage: model.listImage, items: uniqueItems.toCoreModel())
    return (model, local)
}

func uniqueItem(date: Date? = nil, isDone: Bool = false) -> (model: FeedToDoItem, local: LocalToDoItem) {
    let model = FeedToDoItem(id: UUID(), title: "a title", isDone: isDone, expectedDate: date, finishedDate: nil, priority: nil, url: nil, note: nil)
    let local = LocalToDoItem(id: model.id, title: model.title, isDone: model.isDone, expectedDate: model.expectedDate, finishedDate: model.finishedDate, priority: model.priority, url: model.url, note: model.note)
    return (model, local)
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
