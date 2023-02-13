//
//  SubTask.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/12.
//

import Foundation

public struct SubTask: Equatable {
    public let id: UUID
    public let isDone: Bool
    public let title: String
    
    public init(id: UUID, isDone: Bool, title: String) {
        self.id = id
        self.isDone = isDone
        self.title = title
    }
}
