//
//  CoreDataFeedStore.swift
//  ToDDoCore
//
//  Created by Min-Yang Huang on 2023/2/20.
//

import CoreData

public class CoreDataFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "ToDDoStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            do {
                let request = NSFetchRequest<ToDDoList>(entityName: ToDDoList.entity().name!)
                request.returnsObjectsAsFaults = false
                let lists = try context.fetch(request).sorted(by: { $0.modificationTime < $1.modificationTime })
                completion(.success(lists.map { $0.localList }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ list: LocalFeedListGroup, timestamp: Date, completion: @escaping InsertionCompletion) {
        let context = self.context
        context.perform {
            do {
                ToDDoList.list(from: list, timestamp: timestamp, in: context)
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ item: LocalToDoItem, timestamp: Date, to list: LocalFeedListGroup, completion: @escaping InsertionCompletion) {
        let context = self.context
        context.perform {
            ToDDoList.find(with: list.id, in: context, completion: { result in
                do {
                    if let coreList = try? result.get() {
                        coreList.addToItem(ToDDoItem.item(from: item, timestamp: timestamp, in: context))
                    } else {
                        // TODO: - Fix timestamp
                        ToDDoList.list(from: list, and: item, timestamp: timestamp, in: context)
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
    
    public func update(_ list: LocalFeedListGroup, timestamp: Date, completion: @escaping UpdateCompletion) {
        let context = self.context
        context.perform {
            ToDDoList.find(with: list.id, in: context) { result in
                do {
                    let savedList = try result.get()
                    if let savedList = savedList {
                        savedList.setValue(list.listTitle, forKey: "title")
                        savedList.setValue(list.listImage, forKey: "image")
                        savedList.setValue(ToDDoItem.item(from: list.items, timestamp: timestamp, in: context), forKey: "item")
                    }
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func update(_ item: LocalToDoItem, timestamp: Date, completion: @escaping UpdateCompletion) {
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
                        savedItem.setValue(timestamp, forKeyPath: "modificationTime")
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

private extension NSPersistentContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
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

