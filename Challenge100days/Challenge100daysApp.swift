//
//  App.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/30.
//

import SwiftUI

@main
struct Challenge100daysApp: App {
    var body: some Scene {
        WindowGroup {
            TabScreen()
                .environment(\.managedObjectContext, PersistenceController.persistentContainer.viewContext)
                .environmentObject(NotificationViewModel())
                .environmentObject(CoreDataStore())
        }
    }
}
