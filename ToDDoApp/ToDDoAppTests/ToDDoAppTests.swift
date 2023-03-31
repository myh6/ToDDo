//
//  ToDDoAppTests.swift
//  ToDDoAppTests
//
//  Created by Min-Yang Huang on 2023/3/31.
//

import XCTest
import CloudKit
import CoreData
import ToDDoApp
import ToDDoCore

final class ToDDoAppTests: XCTestCase {


    func test_init() throws {
        
        let _ = try XCTUnwrap(CoreDataFeedStore(contianer: NSPersistentCloudKitContainer.load(identifier: "iCloud.com.toddo.test", modelName: "ToDDoStore", in: Bundle(for: CoreDataFeedStore.self))))
    }
    
}

private extension NSPersistentCloudKitContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistnetStore(Swift.Error)
    }
    
    static func load(identifier: String, modelName name: String, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        let cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: identifier)
        let description = NSPersistentStoreDescription()
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.cloudKitContainerOptions = cloudKitContainerOptions
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores {
            loadError = $1
        }
        try loadError.map { throw LoadingError.failedToLoadPersistnetStore($0) }
        return container
    }
}
