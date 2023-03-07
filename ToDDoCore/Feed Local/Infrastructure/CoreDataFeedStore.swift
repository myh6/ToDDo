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
                let toDoList = ToDDoList(context: context)
                toDoList.id = list.id
                toDoList.title = list.listTitle
                toDoList.image = list.listImage
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ item: LocalToDoItem, to list: LocalFeedListGroup, completion: @escaping InsertionCompletion) {
    }
    
    public func remove(_ feed: LocalFeedListGroup, completion: @escaping RemovalCompletion) {
        
    }
    
    public func update(_ feed: LocalFeedListGroup, completion: @escaping UpdateCompletion) {
        
    }
    
    public func hasItem(withID: UUID) -> Bool {
        return false
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

