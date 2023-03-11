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
                guard !self.hasItem(with: list.id) else { return completion(.success(())) }
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
        ToDDoList.find(with: list.id, in: context, completion: { result in
            switch result {
            case let .success(coreList):
                context.perform {
                    do {
                        guard !self.hasItem(with: item.id) else { return completion(.success(())) }
                        if let coreList = coreList {
                            coreList.addToItem(ToDDoItem.item(from: item, in: context))
                        } else {
                            ToDDoList.list(from: list, and: item, in: context)
                        }
                        try context.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    public func remove(_ list: LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        let context = self.context
        if hasItem(with: list.id) {
            ToDDoList.find(with: list.id, in: context) { result in
                context.perform {
                    do {
                        try result.get().map(context.delete).map(context.save)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            completion(.success(()))
        }
    }
    
    public func remove(_ item: LocalToDoItem, from list: LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        let context = self.context
        if hasItem(with: item.id) {
            ToDDoItem.find(with: item.id, in: context) { result in
                context.perform {
                    do {
                        try result.get().map(context.delete).map(context.save)
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            completion(.success(()))
        }
        
    }
    
    public func update(_ feed: LocalFeedListGroup, completion: @escaping UpdateCompletion) {
        
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

