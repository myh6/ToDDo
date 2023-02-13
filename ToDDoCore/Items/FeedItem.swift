//
//  FeedItem.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/12.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let expectedDate: Date
    public let finishedDate: Date
    public let priority: Int
    public let title: String
    public let isDone: Bool
    public let url: URL?
    public let note: String?
    public let tag: String?
    public let imageData: Data?
    public let subTasks: SubTask
}
