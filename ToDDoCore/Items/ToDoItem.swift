//
//  ToDoItem.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/10.
//

import Foundation

struct FeedCategory {
    let category: String
    let itemsList: [FeedItem]
}

struct FeedItem {
    let id : UUID
    let title : String
    let isDone : Bool
    let expectedDate : Date?
    let finishedDate : Date?
    let priority : Int?
    let url : URL?
    let note : String?
    let tag : String?
    let imageData : Data?
    let subTasks : SubTasks?
}

struct SubTasks {
    let id : UUID
    let isDone : Bool
    let title :  String
}
