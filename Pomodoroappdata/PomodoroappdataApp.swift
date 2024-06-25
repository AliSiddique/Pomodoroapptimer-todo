//
//  PomodoroappdataApp.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/01/2024.
//

import SwiftUI
import UIKit
import RevenueCat
@main
struct PomodoroappdataApp: App {
    @StateObject var userViewModel = UserViewModel()
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    init(){
//        Purchases.configure(withAPIKey: "appl_xGRTznZjhmwqDLPinoNLpVDjFoV")
//        Purchases.logLevel = .debug
//        Purchases.shared.delegate = self // make sure to set this after calling configure
//
//    }
    var body: some Scene {
        WindowGroup {
            if isOnboarding != nil {
                ContentView()
                    .preferredColorScheme(.dark)

            } else {
                OnboardingView()
                    .preferredColorScheme(.dark)
            }

        }
        .environmentObject(userViewModel)
        

       
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
