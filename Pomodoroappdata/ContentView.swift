//
//  ContentView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/01/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        HomeView()
            .environmentObject(pomodoroModel)
    }
}


#Preview {
    ContentView()
        .environmentObject(PomodoroModel())
}
