//
//  Task.swift
//  daily-planner-ios
//
//  Created by Ali Siddique on 26/06/2024.
//


import SwiftUI
import SwiftData

@Model
class Tasks: Identifiable {
    var id: UUID
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool
    var tint: String
    @Relationship(deleteRule: .cascade) var pomodoroSessions: [PomodoroSession]?
    
    init(id: UUID = .init(), taskTitle: String, creationDate: Date = .init(), isCompleted: Bool = false, tint: String) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
        self.pomodoroSessions = []
    }
    
    var tintColor: Color {
        switch tint {
        case "TaskColor 1": return .taskColor1
        case "TaskColor 2": return .taskColor2
        case "TaskColor 3": return .taskColor3
        case "TaskColor 4": return .taskColor4
        case "TaskColor 5": return .taskColor5
        default: return .black
        }
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
import SwiftData
import SwiftUI

@Model
class PomodoroSession: Identifiable {
    var id: UUID
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval
    var isCompleted: Bool
    var isWorkSession: Bool
    var associatedTask: Tasks?
    
    init(id: UUID = UUID(), startTime: Date = Date(), endTime: Date? = nil, duration: TimeInterval, isCompleted: Bool = false, isWorkSession: Bool, associatedTask: Tasks? = nil) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.isCompleted = isCompleted
        self.isWorkSession = isWorkSession
        self.associatedTask = associatedTask
    }
}
