//
//  Challenge100daysApp.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI

@main
struct Challenge100daysApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            //TutorialView3()
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
