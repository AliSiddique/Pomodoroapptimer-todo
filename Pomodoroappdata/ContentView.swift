//
//  ContentView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 22/06/2024.
//
import SwiftUI
struct ContentView: View {
    
    var body: some View {
        TabView {
            
            TimerView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Chart")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .background(Color("BG")).ignoresSafeArea()
        
    }
}
#Preview {
    ContentView()
}
