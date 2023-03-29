//
//  SelectableMenuStore.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import Foundation

public class SelectableMenuStore: ObservableObject {
    @Published public var options: [Option]
    
    public private(set) var selectedOptionIndex = 0
    public var selectedOptionText: String {
        options[selectedOptionIndex].text
    }
    
    private let didSelect: (String) -> Void
    
    public init(options: [String], didSelect: @escaping (String) -> Void) {
        self.options = options.map { Option(text: $0) }
        self.didSelect = didSelect
        guard !options.isEmpty else { return }
        self.options[0].isSelected = true
        
        didSelect(selectedOptionText)
    }
    
    public func selectOption(at index: Int) {
        guard options.indices.contains(index) else { return }
        options = options.enumerated().map { i, option in
            var option = option
            option.isSelected = (i == index)
            return option
        }
        selectedOptionIndex = index
        didSelect(selectedOptionText)
    }
    
}

public struct Option: Equatable {
    public let text: String
    public var isSelected: Bool = false
}
