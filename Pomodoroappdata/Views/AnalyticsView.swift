import SwiftUI
import SwiftData
import Charts
import RevenueCatUI
enum TimeRange: String, CaseIterable {
    case week = "Last 7 Days"
    case month = "Last Month"
    case year = "Last Year"
}

struct PomodoroAnalyticsData {
    var workSessionsCount: Int = 0
    var breakSessionsCount: Int = 0
    var completedWorkSessionsCount: Int = 0
    var completedBreakSessionsCount: Int = 0
    var dailyProductivity: [Date: TimeInterval] = [:]
    var averageSessionDuration: TimeInterval = 0
}

struct AnalyticsView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Query var tasks: [Tasks]
    @Query var pomodoroSessions: [PomodoroSession]
    @State private var selectedTimeRange: TimeRange = .week
    @State private var pomodoroData: PomodoroAnalyticsData = PomodoroAnalyticsData()
    @State private var completedTasksCount: Int = 0
    @State private var uncompletedTasksCount: Int = 0
    @State private var completedTasksChange: Double = 0
    @State private var uncompletedTasksChange: Double = 0
    @State var displayPaywall = false
    var body: some View {
        ZStack {
                ScrollView {
                    ZStack {
                        VStack(spacing: 20) {
                            Text("Pomodoro Analytics")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Picker("Time Range", selection: $selectedTimeRange) {
                                ForEach(TimeRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            VStack {
                                HStack(spacing: 15) {
                                    PomodoroCountCard(title: "Work Sessions", count: pomodoroData.workSessionsCount, color: .blue.opacity(0.4))
                                    PomodoroCountCard(title: "Break Sessions", count: pomodoroData.breakSessionsCount, color: .orange.opacity(0.4))
                                }
                                HStack {
                                    TaskCountCard(title: "Completed", count: completedTasksCount, color: .green.opacity(0.4), change: completedTasksChange, timeRange: selectedTimeRange)
                                    TaskCountCard(title: "Uncompleted", count: uncompletedTasksCount, color: .red, change: uncompletedTasksChange, timeRange: selectedTimeRange)
                                }
                            }
                            
                            PomodoroCompletionRateChart(workSessions: pomodoroData.workSessionsCount, completedWorkSessions: pomodoroData.completedWorkSessionsCount, breakSessions: pomodoroData.breakSessionsCount, completedBreakSessions: pomodoroData.completedBreakSessionsCount)
                                .frame(height: 200)
                                .padding()
                                .background(Color("DarkBlue"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            
                            PomodoroProductivityChart(data: pomodoroData.dailyProductivity)
                                .frame(height: 200)
                                .padding()
                                .background(Color("AccentColor"))
                                .cornerRadius(10)
                                .foregroundColor(.white)

                            // Uncomment if you want to include this view
                            // AverageSessionDurationView(averageDuration: pomodoroData.averageSessionDuration)
                            //     .padding()
                            //     .background(Color("DarkBlue").opacity(0.4))
                            //     .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                .blur(radius: userViewModel.isSubscriptionActive ? 0 : 10)
                
                if !userViewModel.isSubscriptionActive {
                    VStack {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text("Analytics Locked")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Subscribe to access detailed analytics")
                            .foregroundColor(.white)
                            .padding()
                        
                        Button(action: {
                            displayPaywall = true
                        }) {
                            Text("Subscribe Now")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.7))
                }
            }
            .preferredColorScheme(.light)
            .onChange(of: selectedTimeRange) { _, _ in
                updateData()
            }
            .onAppear {
                updateData()
            }
            .sheet(isPresented: $displayPaywall) {
                PaywallView(displayCloseButton: true)
            }
        }
    
    
    func updateData() {
        pomodoroData = calculatePomodoroAnalytics(sessions: pomodoroSessions, for: selectedTimeRange)
        updateTaskData()
    }

    func updateTaskData() {
        let (completed, uncompleted) = calculateTaskCounts(tasks: tasks, for: selectedTimeRange)
        completedTasksCount = completed
        uncompletedTasksCount = uncompleted
        
        let (prevCompleted, prevUncompleted) = calculateTaskCounts(tasks: tasks, for: previousTimeRange(of: selectedTimeRange))
        
        completedTasksChange = calculatePercentageChange(from: prevCompleted, to: completed)
        uncompletedTasksChange = calculatePercentageChange(from: prevUncompleted, to: uncompleted)
    }

    func calculateTaskCounts(tasks: [Tasks], for timeRange: TimeRange) -> (Int, Int) {
        let filteredTasks = filterTasks(tasks, for: timeRange)
        let completed = filteredTasks.filter { $0.isCompleted }.count
        let uncompleted = filteredTasks.count - completed
        return (completed, uncompleted)
    }

    func filterTasks(_ tasks: [Tasks], for timeRange: TimeRange) -> [Tasks] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch timeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now)!
        }
        
        return tasks.filter { $0.creationDate >= startDate && $0.creationDate <= now }
    }

    func previousTimeRange(of timeRange: TimeRange) -> TimeRange {
        switch timeRange {
        case .week:
            return .week // Previous week
        case .month:
            return .month // Previous month
        case .year:
            return .year // Previous year
        }
    }

    func calculatePercentageChange(from oldValue: Int, to newValue: Int) -> Double {
        guard oldValue != 0 else { return 0 }
        return Double(newValue - oldValue) / Double(oldValue) * 100
    }

    func calculatePomodoroAnalytics(sessions: [PomodoroSession], for timeRange: TimeRange) -> PomodoroAnalyticsData {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch timeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now)!
        }
        
        let filteredSessions = sessions.filter { $0.startTime >= startDate && $0.startTime <= now }
        
        var data = PomodoroAnalyticsData()
        data.workSessionsCount = filteredSessions.filter { $0.isWorkSession }.count
        data.breakSessionsCount = filteredSessions.filter { !$0.isWorkSession }.count
        data.completedWorkSessionsCount = filteredSessions.filter { $0.isWorkSession && $0.isCompleted }.count
        data.completedBreakSessionsCount = filteredSessions.filter { !$0.isWorkSession && $0.isCompleted }.count
        
        for session in filteredSessions where session.isCompleted {
            let day = calendar.startOfDay(for: session.startTime)
            data.dailyProductivity[day, default: 0] += session.duration
        }
        
        let totalDuration = filteredSessions.reduce(0) { $0 + $1.duration }
        data.averageSessionDuration = filteredSessions.isEmpty ? 0 : totalDuration / Double(filteredSessions.count)
        
        return data
    }
}
struct PomodoroCountCard: View {
    var title: String
    var count: Int
    var color: Color
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(title)
                .font(.headline)
            Text("\(count)")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding()
        .background(Color("DarkBlue"))
        .cornerRadius(10)
    }
}

struct PomodoroCompletionRateChart: View {
    var workSessions: Int
    var completedWorkSessions: Int
    var breakSessions: Int
    var completedBreakSessions: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Session Completion Rates")
                .font(.headline)
            
            Chart {
                BarMark(
                    x: .value("Type", "Work"),
                    y: .value("Completed", completedWorkSessions)
                        
                        
                )
                .foregroundStyle(.blue)
                
                
                BarMark(
                    x: .value("Type", "Work"),
                    y: .value("Incomplete", workSessions - completedWorkSessions)
                )
                .foregroundStyle(.blue.opacity(0.3))
                
                BarMark(
                    x: .value("Type", "Break"),
                    y: .value("Completed", completedBreakSessions)
                )
                .foregroundStyle(.orange)
                
                BarMark(
                    x: .value("Type", "Break"),
                    y: .value("Incomplete", breakSessions - completedBreakSessions)
                )
                .foregroundStyle(.orange.opacity(0.3))
            }
            .chartXAxis {
                           AxisMarks { _ in
                               AxisValueLabel()
                                   .foregroundStyle(.white)
                           }
                       }
            
        }
    }
}

struct PomodoroProductivityChart: View {
    var data: [Date: TimeInterval]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Productivity")
                .font(.headline)
            
            Chart {
                ForEach(data.sorted(by: { $0.key < $1.key }), id: \.key) { date, duration in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Duration", duration / 3600) // Convert to hours
                    )
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", date),
                        y: .value("Duration", duration / 3600)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue.opacity(0.1))
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel("\(value.index) h")
                }
            }
        }
    }
}

struct AverageSessionDurationView: View {
    var averageDuration: TimeInterval
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Average Session Duration")
                .font(.headline)
            
            Text(String(format: "%.1f minutes", averageDuration / 60))
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    AnalyticsView(userViewModel: UserViewModel())
}
struct TaskCountCard: View {
    var title: String
    var count: Int
    var color: Color
    var change: Double
    var timeRange: TimeRange
    
    var body: some View {
        VStack(spacing:4) {
            HStack {
                Image(systemName: "star")
                Text(title)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(count)")
                .fontWeight(.bold)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: change >= 0 ? "arrow.up" : "arrow.down")
                Text(String(format: "%.1f%%", abs(change)))
            }
            .foregroundColor(change >= 0 ? .green : .red)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("vs previous \(timeRange.rawValue.lowercased())")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color("AccentColor"))
        .font(.system(size: 13, design: .monospaced))
        .mask(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .cyan]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )        )
    }
}
