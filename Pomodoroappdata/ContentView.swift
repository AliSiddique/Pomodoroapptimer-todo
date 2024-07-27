//
//  ContentView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 22/06/2024.
//
import SwiftUI
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            TimerView(modelContext: modelContext)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Timer")
                }
            AnalyticsView(userViewModel: UserViewModel())
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
            SettingsView(userViewModel: UserViewModel())
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .preferredColorScheme(.light)

        
    }
}
#Preview {
    ContentView()
}
