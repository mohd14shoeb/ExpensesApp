//
//  DatabaseHandler.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 28/11/21.
//

import UIKit
import CoreData

class DatabaseHandler {
     var viewContext: NSManagedObjectContext?
    static let shared = DatabaseHandler()
    init() {
        viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        viewContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func add<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let entityName = T.entity().name else {return nil}
        guard let managedObjectContext = viewContext else {return nil}
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) else {return nil}
        let object = T(entity: entity, insertInto: managedObjectContext)
        return object
    }
   
    func save() {
        guard let managedObjectContext = viewContext else {return}
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T]? {
        guard let managedObjectContext = viewContext else {return []}
        let request = T.fetchRequest()
        do {
             let result = try managedObjectContext.fetch(request)
            return result as? [T]
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    func delete<T: NSManagedObject>(object: T) {
        guard let managedObjectContext = viewContext else {return}
        managedObjectContext.delete(object)
        save()
    }
}
