//
//  DataController.swift
//  Bookworm
//
//  Created by Paul Hudson on 23/11/2021.
//


import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "challengedDay")
    //    static let shared = PersistenceController()
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

///__App.swiftに書くやつ
/*
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
 
 */



///各ビューのビューではこう
/*
 ///CoreData用の変数
 @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
 @Environment(\.managedObjectContext) var moc
 
 */

///各ビューのプレビューではこう
/*
 struct CardView_Previews: PreviewProvider {
 static private var dataController = DataController()
 static var previews: some View {
 Group{
 CardView()
 .environment(\.locale, Locale(identifier:"en"))
 CardView()
 .environment(\.locale, Locale(identifier:"ja"))
 }.environmentObject(NotificationViewModel())
 }
 }

 */


///コードで全件取得
/*
 func getAll(){
 let context = DataController()
 let cc = context.container.viewContext
 let req = NSFetchRequest<DailyData>(entityName: "DailyData")
 do{
 let tasks = try cc.fetch(req)
 print(tasks)
 }catch{
 fatalError()
 }
 }
 
 
 
 /////全件表示関数
 //func getAllData() -> [Entity]{
 //    //すべてのデータを取り出す
 //    let persistenceController = PersistenceController.shared
 //    let context = persistenceController.container.viewContext
 //    let request = NSFetchRequest<Entity>(entityName: "Entity")
 //    //request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
 //
 //    do{let tasks = try context.fetch(request)
 //        return tasks
 //    }catch{
 //        fatalError()
 //    }
 //}
 */



