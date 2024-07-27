//
//  PomodoroappdataApp.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/01/2024.
//

import SwiftUI
import UIKit
import RevenueCat
import SwiftData
@main
struct PomodoroappdataApp: App {
    @StateObject var userViewModel = UserViewModel()
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Tasks.self,PomodoroSession.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init(){
        Purchases.configure(withAPIKey: "appl_xGRTznZjhmwqDLPinoNLpVDjFoV")
        Purchases.logLevel = .debug

    }
    var body: some Scene {
        WindowGroup {
            if isOnboarding != nil {
                ContentView()
                    .preferredColorScheme(.light)

            } else {
                OnboardingView()
                    .preferredColorScheme(.light)
            }

        }
        .environmentObject(userViewModel)
        .modelContainer(sharedModelContainer)
        

       
    }
}
class AppDelegate: NSObject, UIApplicationDelegate, PurchasesDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.logLevel = .debug
          Purchases.configure(withAPIKey: "appl_xGRTznZjhmwqDLPinoNLpVDjFoV")
          Purchases.shared.delegate = self // make sure to set this after calling configure

          return true
      }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Your code to handle entering background
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Your code to handle entering foreground
    }
}
