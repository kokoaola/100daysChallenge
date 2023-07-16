//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        Button("Open Settings") {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
