//
//  CloudKitFeedStore.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/3/17.
//

import CoreData
import CloudKit

public class CloudKitFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    public init(identifier: String, storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentCloudKitContainer.load(identifier: identifier, modelName: "ToDDoStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            do {
                let request = NSFetchRequest<ToDDoList>(entityName: ToDDoList.entity().name!)
                request.returnsObjectsAsFaults = false
                let lists = try context.fetch(request)
                completion(.success(lists.map { $0.localList }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ list: LocalFeedListGroup, completion: @escaping InsertionCompletion) {
        let context = self.context
        context.perform {
            do {
                ToDDoList.list(from: list, in: context)
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ item: LocalToDoItem, to list: LocalFeedListGroup, completion: @escaping InsertionCompletion) {
        let context = self.context
        context.perform {
            ToDDoList.find(with: list.id, in: context, completion: { result in
                do {
                    if let coreList = try? result.get() {
                        coreList.addToItem(ToDDoItem.item(from: item, in: context))
                    } else {
                        ToDDoList.list(from: list, and: item, in: context)
                    }
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            })
        }
    }
    
    public func remove(_ list: LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        let context = self.context
        context.perform {
            ToDDoList.find(with: list.id, in: context) { result in
                do {
                    try result.get().map(context.delete).map(context.save)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func remove(_ item: LocalToDoItem, from list: LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        let context = self.context
        context.perform {
            ToDDoItem.find(with: item.id, in: context) { result in
                do {
                    try result.get().map(context.delete).map(context.save)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func update(_ list: LocalFeedListGroup, completion: @escaping UpdateCompletion) {
        let context = self.context
        context.perform {
            ToDDoList.find(with: list.id, in: context) { result in
                do {
                    let savedList = try result.get()
                    if let savedList = savedList {
                        savedList.setValue(list.listTitle, forKey: "title")
                        savedList.setValue(list.listImage, forKey: "image")
                        savedList.setValue(ToDDoItem.item(from: list.items, in: context), forKey: "item")
                    }
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func update(_ item: LocalToDoItem, completion: @escaping UpdateCompletion) {
        let context = self.context
        context.perform {
            ToDDoItem.find(with: item.id, in: context) { result in
                do {
                    let savedItem = try result.get()
                    if let savedItem = savedItem {
                        savedItem.setValue(item.title, forKey: "title")
                        savedItem.setValue(item.priority, forKey: "priority")
                        savedItem.setValue(item.expectedDate, forKey: "expectedDate")
                        savedItem.setValue(item.finishedDate, forKey: "finishedDate")
                        savedItem.setValue(item.url, forKey: "url")
                        savedItem.setValue(item.isDone, forKey: "isDone")
                        savedItem.setValue(item.note, forKey: "note")
                    }
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func hasItem(with id: UUID) -> Bool {
        switch (ToDDoList.find(with: id, in: context), ToDDoItem.find(with: id, in: context)) {
        case (true, _):
            return true
            
        case (_, true):
            return true
            
        default:
            return false
        }
    }
    
}

private extension NSPersistentCloudKitContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    static func load(identifier: String, modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
                
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        let cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: identifier)
        let description = NSPersistentStoreDescription(url: url)
        description.cloudKitContainerOptions = cloudKitContainerOptions
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        
        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

