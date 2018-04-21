//
//  DataController.swift
//  Notes
//
//  Created by Admin on 21.04.18.
//  Copyright © 2018 Nikitc. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        guard let modelURL = Bundle.main.url(forResource: "NotesDataModel", withExtension: "momd") else { fatalError("Failed get url")}
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("Failed get model") }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex - 1]
        let storeURL = docURL.appendingPathComponent("NotesDataModel.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        }
        catch {
            fatalError("Failet build persistentStore")
        }
    }
}
