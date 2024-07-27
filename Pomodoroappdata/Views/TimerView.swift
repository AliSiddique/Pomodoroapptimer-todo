//
//  TimerView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 24/06/2024.
//

import SwiftUI
import Combine
import UserNotifications
import SwiftData

class TimerViewModel: ObservableObject {
    @AppStorage("workDuration") var workDuration: TimeInterval = 25 * 60
    @AppStorage("breakDuration") var breakDuration: TimeInterval = 5 * 60
    @AppStorage("longBreakDuration") var longBreakDuration: TimeInterval = 30 * 60
    @Published var roundsBeforeLongBreak: Int {
        didSet {
            UserDefaults.standard.set(roundsBeforeLongBreak, forKey: "roundsBeforeLongBreak")
        }
    }
    @AppStorage("autoStartBreak") private var autoStartBreak: Bool = false
    @Published var isWorkTime: Bool
    @Published var timeRemaining: TimeInterval
    @Published var timerActive: Bool
    @Published var roundsCompleted: Int
    @Published var isLongBreak: Bool
    @Published var currentRound: Int = 1

    private var timer: Timer?
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    private var backgroundRefreshTimer: Timer?
    private var lastUpdate: Date?
    private var currentSession: PomodoroSession?
    private var modelContext: ModelContext
    var associatedTask: Tasks?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.isWorkTime = true
        self.timerActive = false
        self.roundsBeforeLongBreak = UserDefaults.standard.integer(forKey: "roundsBeforeLongBreak")
        self.roundsCompleted = 0
        self.isLongBreak = false
        self.timeRemaining = 0
        initializeTimeRemaining()
        requestNotificationPermission()
    }

    private func initializeTimeRemaining() {
        self.timeRemaining = self.workDuration
    }

    var progress: Double {
        let totalDuration = isWorkTime ? workDuration : (isLongBreak ? longBreakDuration : breakDuration)
        return 1 - (timeRemaining / totalDuration)
    }

    func startTimer() {
        if timerActive { return }
        timerActive = true
        lastUpdate = Date()
        if timeRemaining == 0 {
            timeRemaining = isWorkTime ? workDuration : (isLongBreak ? longBreakDuration : breakDuration)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
        }
        startBackgroundTask()

        startNewSession()
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerActive = false
        endBackgroundTask()

        endCurrentSession(completed: false)
    }

    func resetTimer() {
        stopTimer()
        isWorkTime = true
        roundsCompleted = 0
        currentRound = 1
        isLongBreak = false
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
            endCurrentSession(completed: true)
            switchTimerMode()
        }
    }


    private func switchTimerMode() {
        endCurrentSession(completed: true)
        if isWorkTime {
            roundsCompleted += 1
            if roundsCompleted == roundsBeforeLongBreak {
                // Time for a long break
                isLongBreak = true
                isWorkTime = false
                timeRemaining = longBreakDuration
            } else {
                // Time for a short break
                isLongBreak = false
                isWorkTime = false
                timeRemaining = breakDuration
            }
        } else {
            // Break is over, start next work session
            isWorkTime = true
            isLongBreak = false
            timeRemaining = workDuration
            if isLongBreak {
                // Reset rounds completed after a long break
                roundsCompleted = 0
            }
        }
        
        print("Switched mode - isWorkTime: \(isWorkTime), isLongBreak: \(isLongBreak), roundsCompleted: \(roundsCompleted)")
        
        if autoStartBreak || isWorkTime {
            startTimer()
        } else {
            timerActive = false
        }
    }
    private func startNewSession() {
        let session = PomodoroSession(
            startTime: Date(),
            duration: isWorkTime ? workDuration : (isLongBreak ? longBreakDuration : breakDuration),
            isWorkSession: isWorkTime,
            associatedTask: associatedTask
        )
        currentSession = session
        modelContext.insert(session)
        try? modelContext.save()
    }

    private func endCurrentSession(completed: Bool) {
        if let session = currentSession {
            session.endTime = Date()
            session.isCompleted = completed
            session.duration = session.startTime.distance(to: session.endTime ?? Date())
            try? modelContext.save()
        }
        currentSession = nil
        lastUpdate = nil
    }

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        if isWorkTime {
            content.title = "Work Session Completed"
            content.body = isLongBreak ? "Time for a long break!" : "Time for a short break!"
        } else {
            content.title = "Break Completed"
            content.body = "Time to get back to work!"
        }
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }

    private func startBackgroundTask() {
        endBackgroundTask() // End any existing background task
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        // Start a timer to refresh the background task every 25 seconds
        backgroundRefreshTimer = Timer.scheduledTimer(withTimeInterval: 25, repeats: true) { [weak self] _ in
            self?.refreshBackgroundTask()
        }
    }

    private func refreshBackgroundTask() {
        endBackgroundTask()
        startBackgroundTask()
    }

    private func endBackgroundTask() {
        backgroundRefreshTimer?.invalidate()
        backgroundRefreshTimer = nil
        
        if backgroundTaskIdentifier != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
        }
    }
}
import SwiftUI

struct TimerView: View {
    @Environment(\.modelContext) private var modelContext
       @StateObject private var viewModel: TimerViewModel
       
       init(modelContext: ModelContext) {
           _viewModel = StateObject(wrappedValue: TimerViewModel(modelContext: modelContext))
       }

    @AppStorage("roundsBeforeLongBreak") var roundsBeforeLongBreak: Int = 4
    var body: some View {
        NavigationView {
            ZStack {
                Color.white

                VStack {
                        Text(viewModel.isWorkTime ? "Work Time" : "Break Time")
                            .font(.largeTitle)
                            .padding()
                            .foregroundStyle(.black)

                        ZStack {
                            CircularProgressView(progress: viewModel.progress)
                                .frame(width: 200, height: 200)
                            
                            Text("\(Int(viewModel.timeRemaining) / 60):\(String(format: "%02d", Int(viewModel.timeRemaining) % 60))")
                                .font(.system(size: 60))
                                .foregroundStyle(.black)
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
                                    .background(Circle().fill(Color("AccentColor")))
                            }

                            Button(action: {
                                viewModel.stopTimer()
                            }) {
                                Image(systemName: "stop.fill")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color("AccentColor")))
                            }

                            Button(action: {
                                viewModel.resetTimer()
                            }) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color("AccentColor")))
                            }
                        }
                        .padding()
                        Text("Round \(viewModel.roundsCompleted + 1) of \(viewModel.roundsBeforeLongBreak)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        HStack {
                            ForEach(0..<roundsBeforeLongBreak, id: \.self) { index in
                                                      TomatoView(isFilled: index < viewModel.roundsCompleted % roundsBeforeLongBreak)
                                                  }
                        }
                        .padding()

                       
                    }
                    
                .navigationBarTitle("Pomodoro Timer", displayMode: .inline)
            }
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
                .foregroundColor(Color("AccentColor"))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
        }
    }
}

import SwiftUI
import SwiftData

struct TomatoView: View {
    var isFilled: Bool

    var body: some View {
        Image(systemName: isFilled ? "circle.fill" : "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(Color("AccentColor"))
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(modelContext: previewModelContext)
    }
    
    static var previewModelContext: ModelContext = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Tasks.self, PomodoroSession.self, configurations: config)
            return container.mainContext
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error.localizedDescription)")
        }
    }()
}
