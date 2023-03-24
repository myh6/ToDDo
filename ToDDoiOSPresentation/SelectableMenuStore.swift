//
//  SelectableMenuStore.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import Foundation

public struct SelectableMenuStore {
    public private(set) var options: [Option]
    
    public private(set) var selectedOptionIndex = 0
    public var selectedOptionText: String {
        options[selectedOptionIndex].text
    }
    
    public init(options: [String]) {
        self.options = options.map { Option(text: $0) }
        self.options[0].isSelected = true
    }
    
    public mutating func selectOption(at index: Int) {
        guard options.indices.contains(index) else { return }
        options = options.enumerated().map { i, option in
            var option = option
            option.isSelected = (i == index)
            return option
        }
        selectedOptionIndex = index
    }
    
}

public struct Option: Equatable {
    public let text: String
    public var isSelected: Bool = false
}
