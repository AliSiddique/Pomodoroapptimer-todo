//
//  PomodoroappdataApp.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/01/2024.
//

import SwiftUI
import UIKit

@main
struct PomodoroappdataApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
       ContentView()

        }
       
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
              if let error = error {
                  print("Request notification authorization error: \(error)")
              }
          }
          return true
      }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Your code to handle entering background
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Your code to handle entering foreground
    }
}
