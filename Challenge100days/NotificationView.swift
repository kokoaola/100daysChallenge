//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI
import UserNotifications



struct NotificationView: View {
    @State private var isNotificationEnabled = false
    let center = UNUserNotificationCenter.current()
    

    
    var body: some View {
        
        
//        Group{
        VStack{
            if isNotificationEnabled{
                Text("通知が許可されたね")
            }else{
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
//        }
        
        .onAppear{
            print("P")
            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if success {
                    print("All set!")
                    isNotificationEnabled = true
                }else {
                    print("!")
                    isNotificationEnabled = false
                }
            }
            
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    // 通知が許可されています
                    isNotificationEnabled = true
                } else {
//                    // 通知が許可されていません
//                    if let url = URL(string: UIApplication.openSettingsURLString) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
                }
            }
        }

//        Button {
//            // Create the URL that deep links to your app's notification settings.
//            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
//                // Ask the system to open that URL.
//                await UIApplication.shared.open(url)
//            }
//        } label: {
//            Text("A")
//        }


    }
}

struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
