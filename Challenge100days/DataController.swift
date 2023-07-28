//
//  DataController.swift
//  Bookworm
//
//  Created by Paul Hudson on 23/11/2021.
//


import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "challengedDay")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
