//
//  DailyData+CoreDataProperties.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/25.
//
//

import Foundation
import CoreData


extension DailyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyData> {
        return NSFetchRequest<DailyData>(entityName: "DailyData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var memo: String?
    @NSManaged public var num: Int16
    
    
    ///オプショナル型をラップ
    public var wrappedDate: Date{
        date ?? Date()
    }
    
    public var wrappedMemo: String{
        memo ?? "Unknown"
    }
    
    public var wrappedNum: Int{
        Int(num)
    }

}
