//
//  ColorSaveUserDefaults.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import Foundation
import SwiftUI
import UIKit

extension Color: RawRepresentable {
    
    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
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
