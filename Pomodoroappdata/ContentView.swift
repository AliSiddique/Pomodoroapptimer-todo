//
//  ContentView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 22/06/2024.
//

import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @AppStorage("workDuration") var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") var breakDuration: TimeInterval = 5 * 60
    @Published var isWorkTime: Bool
    @Published var timeRemaining: TimeInterval
    @Published var timerActive: Bool
    @Published var autoStartBreak: Bool
    @Published var roundsCompleted: Int

    private var timer: Timer?
    
    init() {
        self.isWorkTime = true
        self.timeRemaining = 0
        self.timerActive = false
        self.autoStartBreak = false
        self.roundsCompleted = 0
    }
    
    var progress: Double {
        let totalDuration = isWorkTime ? workDuration : breakDuration
        return 1 - (timeRemaining / totalDuration)
    }
    
    func startTimer() {
        if timerActive { return }
        timerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timerActive = false
    }
    
    func resetTimer() {
        stopTimer()
        isWorkTime = true
        roundsCompleted = 0
        timeRemaining = workDuration
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timerActive = false
            switchTimerMode()
        }
    }
    
    private func switchTimerMode() {
        if isWorkTime {
            isWorkTime = false
            timeRemaining = breakDuration
            if autoStartBreak {
                startTimer()
            }
        } else {
            isWorkTime = true
            timeRemaining = workDuration
            roundsCompleted += 1
            if roundsCompleted < 5 {
                startTimer()
            }
        }
    }
}

import SwiftUI

struct SettingsView: View {
    @AppStorage("workDuration") private var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") private var breakDuration: TimeInterval = 5 * 60

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Work Duration")) {
                    DurationPicker(duration: $workDuration)
                }

                Section(header: Text("Break Duration")) {
                    DurationPicker(duration: $breakDuration)
                }
            }
            .navigationBarTitle("Settings")
        }
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
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.isWorkTime ? "Work Time" : "Break Time")
                    .font(.largeTitle)
                    .padding()

                ZStack {
                    CircularProgressView(progress: viewModel.progress)
                        .frame(width: 200, height: 200)
                    
                    Text("\(Int(viewModel.timeRemaining) / 60):\(String(format: "%02d", Int(viewModel.timeRemaining) % 60))")
                        .font(.system(size: 60))
                }
                .padding()

                HStack {
                    Button(action: {
                        viewModel.startTimer()
                    }) {
                        Text("Start")
                            .font(.title)
                            .padding()
                    }

                    Button(action: {
                        viewModel.stopTimer()
                    }) {
                        Text("Stop")
                            .font(.title)
                            .padding()
                    }

                    Button(action: {
                        viewModel.resetTimer()
                    }) {
                        Text("Reset")
                            .font(.title)
                            .padding()
                    }
                }
                .padding()

                Text("Rounds Completed: \(viewModel.roundsCompleted)")
                    .font(.title)
                    .padding()

                Toggle(isOn: $viewModel.autoStartBreak) {
                    Text("Auto Start Break")
                }
                .padding()

                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .font(.title)
                        .padding()
                }
                .disabled(viewModel.timerActive)
            }
            .navigationBarTitle("Pomodoro Timer", displayMode: .inline)
        }
    }
}

import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(.gray)

            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
        }
    }
}


#Preview {
    ContentView()
}
