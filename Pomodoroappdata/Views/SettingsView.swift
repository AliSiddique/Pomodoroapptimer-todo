//
//  SettingsView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/06/2024.
//
import SwiftUI
import RevenueCatUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    @StateObject private var notificationManager = NotificationPermissionManager()
     @State private var showingPermissionAlert = false
    @AppStorage("workDuration") private var workDuration: TimeInterval = 25 * 60
       @AppStorage("breakDuration") private var breakDuration: TimeInterval = 5 * 60
       @AppStorage("longBreakDuration") private var longBreakDuration: TimeInterval = 30 * 60
       @AppStorage("roundsBeforeLongBreak") private var roundsBeforeLongBreak: Int = 4
       @AppStorage("autoStartBreak") private var autoStartBreak: Bool = false
       @ObservedObject var userViewModel: UserViewModel
       @State private var displayPaywall = false
    let center = AuthorizationCenter.shared
    @StateObject private var manager = ShieldManager()
    @State private var showActivityPicker = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                Form {
                     
                    
                    Section(header: Text("Timer")) {
                        HStack {
                            Image(systemName: "clock")
                            DurationPicker(text:"Work",duration: $workDuration, userViewModel: userViewModel)
                        }
                        
                        .onTapGesture {
                                    if !userViewModel.isSubscriptionActive {
                                        displayPaywall = true
                                    }
                                }
                        HStack {
                            Image(systemName: "clock.badge.checkmark")
                            DurationPicker(text:"Break",duration: $breakDuration, userViewModel: userViewModel)
                        }
                        .onTapGesture {
                                    if !userViewModel.isSubscriptionActive {
                                        displayPaywall = true
                                    }
                                }
                        HStack {
                            Image(systemName: "clock.badge")
                            DurationPicker(text:"Long Break",duration: $longBreakDuration, userViewModel: userViewModel)
                        }
                        .onTapGesture {
                                    if !userViewModel.isSubscriptionActive {
                                        displayPaywall = true
                                    }
                                }
                        HStack {
                                  Image(systemName: "repeat")
                                  if userViewModel.isSubscriptionActive {
                                      Picker("Rounds", selection: $roundsBeforeLongBreak) {
                                          ForEach(1...10, id: \.self) { number in
                                              Text("\(number) round\(number == 1 ? "" : "s")")
                                          }
                                      }
                                  } else {
                                      HStack {
                                          Text("Repeat")
                                          Spacer()

                                          Text("\(roundsBeforeLongBreak) round\(roundsBeforeLongBreak == 1 ? "" : "s")")
                                          Image(systemName: "chevron.up.chevron.down")
                                      }
                                      .contentShape(Rectangle())
                                      .onTapGesture {
                                          displayPaywall = true
                                      }
                                  }
                              }
                    
                        Toggle(isOn: $autoStartBreak) {
                            Text("Auto Start Break")
                        }
                    }
                    .foregroundColor(.black)
             
                    Section("General") {
                        if userViewModel.isSubscriptionActive == false {
                                 Button(action: {
                                     displayPaywall = true
                                 }, label: {
                                     HStack {
                                         Image(systemName: "list.bullet")
                                         Text("Configure")

                                         Spacer()
                                         Image(systemName: "lock")
                                     }
                                 })
                                 .foregroundColor(.black)
                             } else {
                                 HStack {
                                     Image(systemName: "list.bullet")
                                     Text("Configure")

                                     Spacer()
                                     Image(systemName: "arrow.down")
     
                                 }
                                 .onTapGesture {
                                       showActivityPicker = true

                                 }
                                 .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)

                                        
                                       }
                        
                        if userViewModel.isSubscriptionActive == false {
                                 Button(action: {
                                     displayPaywall = true
                                 }, label: {
                                     HStack {
                                         Image(systemName: "shield")
                                         Text("Block")

                                         Spacer()
                                         Image(systemName: "lock")
                                     }
                                 })
                                 .foregroundColor(.black)
                        } else {
                            ShieldToggle(manager: manager)

                        }
                     
                        HStack {
                            Image(systemName: "bell")
                         
                            Toggle("Notifications", isOn: $notificationManager.isNotificationEnabled)
                                .onChange(of: notificationManager.isNotificationEnabled) { newValue in
                                    if newValue {
                                        notificationManager.requestNotificationPermission()
                                    } else {
                                        showingPermissionAlert = true
                                    }
                                }
                        }
                             }
                    Section("About") {
                        NavigationLink {
                            Aboutus()
                        } label: {
                            HStack {
                                Image(systemName: "questionmark")
                                Text("About us")
                            }
                        }
                        NavigationLink {
                            HowItWorksView()
                        } label: {
                            HStack {
                                Image(systemName: "arrowshape.forward")
                                Text("How it works")
                            }
                        }
                        HStack {
                            Image(systemName: "star")
                            Text("Rate the App")
                        }
                        .onTapGesture {
                            requestReview()
                        }
                        
                        
                    }
                   
//
                }
                .navigationBarTitle("Settings")
            }
            .sheet(isPresented: $displayPaywall) {
                PaywallView(displayCloseButton: true)
            }
        }
        .preferredColorScheme(.light)

        .onAppear {
                   notificationManager.checkNotificationStatus()
               }
               .alert("Notification Settings", isPresented: $showingPermissionAlert) {
                   Button("Open Settings", role: .none) {
                       notificationManager.openAppSettings()
                   }
                   Button("Cancel", role: .cancel) {
                       notificationManager.isNotificationEnabled = true
                   }
               } message: {
                   Text("To disable notifications, please go to the app settings.")
               }
              
    }
    
}

struct TimerSettingsView: View {
    @AppStorage("workDuration") private var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") private var breakDuration: TimeInterval = 5 * 60

    var body: some View {
        Form {
//            Section(header: Text("Work Duration")) {
//                DurationPicker(duration: $workDuration)
//            }
//
//            Section(header: Text("Break Duration")) {
//                DurationPicker(duration: $breakDuration)
//            }
        }
        .navigationBarTitle("Change Timer")
    }
}

struct DurationPicker: View {
    var text:String
    @Binding var duration: TimeInterval
    @ObservedObject var userViewModel: UserViewModel
    @State var displayWall = false
    var body: some View {
        Menu {
            ForEach(1...60, id: \.self) { minute in
                Button(action: {
                    
                    duration = TimeInterval(minute * 60)
                   
                }) {
                    Text("\(minute) minute\(minute == 1 ? "" : "s")")
                }
               
            }
        } label: {
            HStack {
                Text(text)
                Spacer()

                Text("\(Int(duration / 60)) minute\(duration == 60 ? "" : "s")")
                Image(systemName:userViewModel.isSubscriptionActive == false ? "lock" : "chevron.up.chevron.down")
            }
            
        }
        
       
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userViewModel: UserViewModel())
    }
}

import SwiftUI

struct Aboutus: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("Logo")
                    .resizable()
                    .mask(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Timely")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Get it done!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 15) {
                    InfoRow(content: "Timely is designed to help students excel in their work by providing tools.")
                    
                }
                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                
                Text("Version 1.0.2")
                    .font(.caption)
                    .padding(.top)
                
//                Link("Visit Our Website", destination: URL(string: "https://www.eduquest.com")!)
//                    .font(.headline)
//                    .foregroundColor(.blue)
//                    .padding()
            }
            .padding()
        }
    }
}

struct InfoRow: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(content)
                .font(.body)
        }
    }
}

#Preview {
    Aboutus()
}
import SwiftUI

struct HowItWorksView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("How Timely Works")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Follow these simple steps to make the most of your study experience")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                ForEach(steps) { step in
                    StepView(step: step)
                }
                
              
            }
        }
    }
    
    let steps: [Step] = [
        Step(
            id: 1,
            title: "Set a task",
            description: "Set a task in the task manager.",
            imageName: "person.crop.circle.badge.plus"
        ),
        Step(
            id: 2,
            title: "Set your timer settings",
            description: "Choose how long you want to study for and how long your break is.",
            imageName: "book.closed"
        ),
        Step(
            id: 3,
            title: "Start your timer.",
            description: "Focus using our exceptional timer.",
            imageName: "questionmark.square"
        )
    ]
}

struct Step: Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
}


struct StepView: View {
    let step: Step
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: step.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Step \(step.id)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(step.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(step.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth:300,maxHeight: 200)
        }
        .padding()
        
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("AccentColor").opacity(0.5)))
        .padding(.horizontal)
    }
}

#Preview {
    HowItWorksView()
}
import SwiftUI
import FamilyControls
import ManagedSettings

class ShieldManager: ObservableObject {
    @Published var discouragedSelections = FamilyActivitySelection()
    @Published var blocked = false
    
    private let store = ManagedSettingsStore()
    
    func toggleShield() {
        if blocked {
            shieldActivities()
        } else {
            deactivateShield()
        }
    }
    
     func shieldActivities() {
        let applications = discouragedSelections.applicationTokens
        let categories = discouragedSelections.categoryTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty ? nil : .specific(categories)
        store.shield.webDomainCategories = categories.isEmpty ? nil : .specific(categories)
        
        DispatchQueue.main.async {
            self.blocked = true
        }
    }
    
     func deactivateShield() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
        
        DispatchQueue.main.async {
            self.blocked = false
        }
    }
}

struct ShieldToggle: View {
    @ObservedObject var manager: ShieldManager
    
    var body: some View {
        HStack {
            Image(systemName: "shield")
            Toggle("Block", isOn: $manager.blocked)
                .onChange(of: manager.blocked) { newValue in
                    if newValue {
                        manager.shieldActivities()
                    } else {
                        manager.deactivateShield()
                    }
                }
        }
    }
}

import SwiftUI
import FamilyControls

struct ShieldView: View {
    
    @StateObject private var manager = ShieldManager()
    @State private var showActivityPicker = false
    
    var body: some View {
        VStack {
            Button {
                showActivityPicker = true
            } label: {
                Label("Configure activities", systemImage: "gearshape")
            }
            .buttonStyle(.borderedProminent)
            Button("Apply Shielding") {
                manager.shieldActivities()
            }
            .buttonStyle(.bordered)
        }
        .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)
    }
}

#Preview{
    ShieldView()
}


struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(Color.pink.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(Image(systemName: icon).foregroundColor(.pink))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

