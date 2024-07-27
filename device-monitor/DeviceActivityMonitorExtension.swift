//
//  DeviceActivityMonitorExtension.swift
//  device-monitor
//
//  Created by Ali Siddique on 11/07/2024.
//

//import DeviceActivity
//
//// Optionally override any of the functions below.
//// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
//class DeviceActivityMonitorExtension: DeviceActivityMonitor {
//    override func intervalDidStart(for activity: DeviceActivityName) {
//        super.intervalDidStart(for: activity)
//        
//        // Handle the start of the interval.
//    }
//    
//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        super.intervalDidEnd(for: activity)
//        
//        // Handle the end of the interval.
//    }
//    
//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventDidReachThreshold(event, activity: activity)
//        
//        // Handle the event reaching its threshold.
//    }
//    
//    override func intervalWillStartWarning(for activity: DeviceActivityName) {
//        super.intervalWillStartWarning(for: activity)
//        
//        // Handle the warning before the interval starts.
//    }
//    
//    override func intervalWillEndWarning(for activity: DeviceActivityName) {
//        super.intervalWillEndWarning(for: activity)
//        
//        // Handle the warning before the interval ends.
//    }
//    
//    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventWillReachThresholdWarning(event, activity: activity)
//        
//        // Handle the warning before the event reaches its threshold.
//    }
//}
import DeviceActivity
import Foundation
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // Handle the end of the interval.
        let database = DataBase()
        guard let activityId = UUID(uuidString: activity.rawValue) else { return }
        guard let application = database.getApplicationProfile(id: activityId) else { return }
        let store = ManagedSettingsStore()
        store.shield.applications?.insert(application.applicationToken)
        database.removeApplicationProfile(application)
    }
}
