//
//  MobileStorage.swift
//  MobileStorageTestTask
//
//  Created by MacPro on 05.09.2022.
//

import Foundation
import CoreData

class MobileStorageImplementation {
    
    enum MobileStorageError: Error {
        case contextError
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var ManagedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
}

//MARK: - MobileStorage protocol

extension MobileStorageImplementation: MobileStorage {
    
    func getAll() -> Set<Mobile> {
        let fetchRequest: NSFetchRequest<Mobile> = Mobile.fetchRequest()
        
        do {
            let mobiles = try ManagedObjectContext.fetch(fetchRequest)
            return Set(mobiles.map { $0 })
            
        } catch let error {
            print(error.localizedDescription)
            return Set<Mobile>()
        }
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        let fetchRequest: NSFetchRequest<Mobile> = Mobile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imei = \(imei)")
        
        do {
            let mobiles = try ManagedObjectContext.fetch(fetchRequest)
            return mobiles.first
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        guard mobile.managedObjectContext == ManagedObjectContext else {
            throw MobileStorageError.contextError
        }
        do {
            try ManagedObjectContext.save()
        } catch let error {
            throw error
        }
        return mobile
    }
    
    func delete(_ product: Mobile) throws {
        do {
            ManagedObjectContext.delete(product)
            try ManagedObjectContext.save()
            
        } catch let error {
            throw error
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        guard let imei = product.imei else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<Mobile> = Mobile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imei = \(imei)")
        
        do {
            let mobiles = try ManagedObjectContext.fetch(fetchRequest)
            return !mobiles.isEmpty
            
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
}
