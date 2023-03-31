//
//  DateTestHelper.swift
//  ToDDoiOSPresentationTests
//
//  Created by Min-Yang Huang on 2023/3/31.
//

import Foundation
import XCTest

extension XCTestCase {
    /// Render date using unix timestamp
    /// - Returns: 2023-03-28 00:00:00
    func renderExactDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = "2023-03-28 00:00:00"
        return dateFormatter.date(from: dateString)!
    }
}
