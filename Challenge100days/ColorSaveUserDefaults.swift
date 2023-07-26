//
//  ColorSaveUserDefaults.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import Foundation
import SwiftUI
import UIKit


extension View{
    public func userSettingGradient(colors:[Color]) -> some View{
        self.background(.secondary).foregroundStyle(LinearGradient(
            colors: [colors[0], colors[1]],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
}

struct UserSettingGradient: ViewModifier{
    let appColorNum: Int
    var colors:[Color]{
        switch appColorNum{
        case 0:
            return [.blue, .green]
        case 1:
            return [.green, .yellow]
        case 2:
            return [.purple, .blue]
        case 3:
            return [.black, .black]
        default:
            return [.blue, .green]
        }
    }
    
    func body(content: Content) -> some View{
        content.background(.secondary).foregroundStyle(LinearGradient(
            colors: [colors[0], colors[1]],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
}



extension Color: RawRepresentable {
    
    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            //let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
    }
    
    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }
    
}

///使う時
/*
 @AppStorage("colorkey") var storedColor: Color = .black

var body: some View {
    
    VStack{
        ColorPicker("Persisted Color Picker", selection: $storedColor, supportsOpacity: true)
    }
}
*/
