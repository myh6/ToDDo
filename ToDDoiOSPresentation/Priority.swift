//
//  Priority.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/27.
//

import Foundation
import SwiftUI

public enum Priority {
    case high
    case medium
    case low
    case none
    
    public var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .blue
        case .none:
            return .gray
        }
    }
}
