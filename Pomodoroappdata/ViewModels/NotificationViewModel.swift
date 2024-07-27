//
//  NotificationViewModel.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 09/07/2024.
//
import SwiftUI
import UserNotifications

class NotificationPermissionManager: ObservableObject {
    @Published var isNotificationEnabled: Bool = false
    
    init() {
        checkNotificationStatus()
    }
    
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.isNotificationEnabled = granted
            }
        }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

struct NotificationSettingsView: View {
    @StateObject private var permissionManager = NotificationPermissionManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Enable Notifications", isOn: $permissionManager.isNotificationEnabled)
                .onChange(of: permissionManager.isNotificationEnabled) { newValue in
                    if newValue {
                        permissionManager.requestNotificationPermission()
                    } else {
                        permissionManager.openAppSettings()
                    }
                }
            
            Text("Notification Status: \(permissionManager.isNotificationEnabled ? "Enabled" : "Disabled")")
            
            Button("Check Notification Status") {
                permissionManager.checkNotificationStatus()
            }
            
            Button("Open App Settings") {
                permissionManager.openAppSettings()
            }
        }
        .padding()
    }
}

#Preview {
    NotificationSettingsView()
}
import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func scheduleEndOfDayNotificationIfNeeded(tasks: [Tasks]) {
        let calendar = Calendar.current
        let now = Date()
        
        // Check if we've already scheduled a notification today
        if let lastScheduled = UserDefaults.standard.object(forKey: "lastNotificationScheduled") as? Date,
           calendar.isDate(lastScheduled, inSameDayAs: now) {
            print("Notification already scheduled for today")
            return
        }
        
        // Request notification permission if not already granted
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.createEndOfDayNotification(tasks: tasks)
                
                // Save the current date as the last scheduled date
                UserDefaults.standard.set(now, forKey: "lastNotificationScheduled")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    private func createEndOfDayNotification(tasks: [Tasks]) {
        let content = UNMutableNotificationContent()
        let incompleteTasks = tasks.filter { !$0.isCompleted && Calendar.current.isDateInToday($0.creationDate) }
        let incompleteCount = incompleteTasks.count
        
        content.title = "Daily Task Summary"
        content.body = incompleteCount > 0 ? "You have \(incompleteCount) incomplete task(s) for today." : "Great job! All tasks for today are complete."
        content.sound = .default
        
        // Set the notification to trigger at 9 PM today
        var dateComponents = DateComponents()
        dateComponents.hour = 21 // 9 PM
        dateComponents.minute = 42
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "endOfDayTaskSummary", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("End of day notification scheduled successfully")
            }
        }
    }
}

// Extension to use this in SwiftUI views
extension View {
    func scheduleEndOfDayNotificationIfNeeded(tasks: [Tasks]) {
        NotificationManager.shared.scheduleEndOfDayNotificationIfNeeded(tasks: tasks)
    }
}
