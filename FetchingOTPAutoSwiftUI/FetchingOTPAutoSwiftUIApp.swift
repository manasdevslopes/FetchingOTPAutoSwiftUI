//
//  FetchingOTPAutoSwiftUIApp.swift
//  FetchingOTPAutoSwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 15/04/22.
//

import SwiftUI
import Firebase

@main
struct FetchingOTPAutoSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    // OTP requires Remote Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}
