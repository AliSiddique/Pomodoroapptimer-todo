//
//  SettingsView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/06/2024.
//

import SwiftUI
import RevenueCatUI

struct SettingsView: View {
    @AppStorage("workDuration") private var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") private var breakDuration: TimeInterval = 5 * 60
    @AppStorage("autoStartBreak") private var autoStartBreak: Bool = false
    @ObservedObject var userViewModel: UserViewModel
    @State
      var displayPaywall = false
    var body: some View {
        NavigationView {
            ZStack {
                Color("BG").ignoresSafeArea()
                Form {
                    Section {
                        Toggle(isOn: $autoStartBreak) {
                            Text("Auto Start Break")
                        }
                    }
                    if userViewModel.isSubscriptionActive == false {
                      
                        Button(action: {
                            displayPaywall = true
                        }, label: {
                            HStack {
                                
                                Image(systemName: "lock")
                                
                                Text("Change Timer")
                                
                            }
                            .foregroundColor(.white)
                        })
                        
                    } else {
                        NavigationLink(destination: TimerSettingsView()) {
                            HStack {
                              
                                
                                Text("Change Timer")
                                
                            }
                        }
                    }
                }
                .navigationBarTitle("Settings")
            }
            .sheet(isPresented: self.$displayPaywall) {
                           PaywallView(displayCloseButton: true)
                       }
        }
    }
}

struct TimerSettingsView: View {
    @AppStorage("workDuration") private var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") private var breakDuration: TimeInterval = 5 * 60

    var body: some View {
        Form {
            Section(header: Text("Work Duration")) {
                DurationPicker(duration: $workDuration)
            }

            Section(header: Text("Break Duration")) {
                DurationPicker(duration: $breakDuration)
            }
        }
        .navigationBarTitle("Change Timer")
    }
}

struct DurationPicker: View {
    @Binding var duration: TimeInterval

    var body: some View {
        Picker(selection: $duration, label: Text("Duration")) {
            ForEach(1..<61) { minute in
                Text("\(minute) minutes").tag(TimeInterval(minute * 60))
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}
#Preview {
    SettingsView(userViewModel: UserViewModel())
     
}
