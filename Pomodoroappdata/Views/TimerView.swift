//
//  TimerView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 24/06/2024.
//


import SwiftUI
import Combine
import UserNotifications

class TimerViewModel: ObservableObject {
    @AppStorage("workDuration") var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") var breakDuration: TimeInterval = 5 * 60
    @AppStorage("autoStartBreak") private var autoStartBreak: Bool = false
    @Published var isWorkTime: Bool
    @Published var timeRemaining: TimeInterval
    @Published var timerActive: Bool
    @Published var roundsCompleted: Int

    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier?
    private var lastUpdate: Date?

    init() {
        self.isWorkTime = true
        self.timeRemaining = 0
        self.timerActive = false
        self.roundsCompleted = 0
    }

    var progress: Double {
        let totalDuration = isWorkTime ? workDuration : breakDuration
        return 1 - (timeRemaining / totalDuration)
    }

    func startTimer() {
        if timerActive { return }
        timerActive = true
        lastUpdate = Date()
        timeRemaining = isWorkTime ? workDuration : breakDuration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
        }
        registerBackgroundTask()
    }

    func stopTimer() {
        timer?.invalidate()
        timerActive = false
        endBackgroundTask()
    }

    func resetTimer() {
        stopTimer()
        isWorkTime = true
        roundsCompleted = 0
        timeRemaining = workDuration
    }

    private func updateTimer() {
        if let lastUpdate = lastUpdate {
            let elapsed = Date().timeIntervalSince(lastUpdate)
            timeRemaining -= elapsed
            self.lastUpdate = Date()
        }
        if timeRemaining <= 0 {
            timerActive = false
            sendNotification()
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

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.body = isWorkTime ? "Work session is over. Take a break!" : "Break is over. Time to work!"
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        if let backgroundTask = backgroundTask {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            self.backgroundTask = .invalid
        }
    }
}

import SwiftUI


struct SettingsView: View {
    @AppStorage("workDuration") private var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") private var breakDuration: TimeInterval = 5 * 60
    @AppStorage("autoStartBreak") private var autoStartBreak: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $autoStartBreak) {
                        Text("Auto Start Break")
                    }
                }
                
                NavigationLink(destination: TimerSettingsView()) {
                    Text("Change Timer")
                }
            }
            .navigationBarTitle("Settings")
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

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color("BG").ignoresSafeArea()
                VStack {
                    Text(viewModel.isWorkTime ? "Work Time" : "Break Time")
                        .font(.largeTitle)
                        .padding()
                        .foregroundStyle(.white)

                    ZStack {
                        CircularProgressView(progress: viewModel.progress)
                            .frame(width: 200, height: 200)
                        
                        Text("\(Int(viewModel.timeRemaining) / 60):\(String(format: "%02d", Int(viewModel.timeRemaining) % 60))")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                    }
                    .padding()

                    HStack {
                        Button(action: {
                            viewModel.startTimer()
                        }) {
                            Image(systemName: "play.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.purple))
                        }

                        Button(action: {
                            viewModel.stopTimer()
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.purple))
                        }

                        Button(action: {
                            viewModel.resetTimer()
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.purple))
                        }
                    }
                    .padding()

                    HStack {
                        ForEach(0..<5) { index in
                            TomatoView(isFilled: index < viewModel.roundsCompleted)
                        }
                    }
                    .padding()

                   
                }
                .background(Color("BG")).edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Pomodoro Timer", displayMode: .inline)
            }
        }
        .background(Color("BG")).edgesIgnoringSafeArea(.all)
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
                .foregroundColor(Color("Purple"))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
        }
    }
}

import SwiftUI

struct TomatoView: View {
    var isFilled: Bool

    var body: some View {
        Image(systemName: isFilled ? "circle.fill" : "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(Color("Purple"))
    }
}

#Preview {
    TimerView()
}
