//
//  TabBarModel.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 02/02/2024.
//

import Foundation
import RiveRuntime
struct TabItem:Identifiable {
    var id = UUID()
    var icon:RiveViewModel
    var tab:Tab
}
var tabItems = [
    TabItem(icon: RiveViewModel(fileName: "icons",
                                stateMachineName: "HOME_interactivity", artboardName: "HOME"),tab: .chat),
    TabItem(icon: RiveViewModel(fileName: "icons",
                                stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH"),tab: .search),
    TabItem(icon: RiveViewModel(fileName: "icons",
                                stateMachineName: "BELL_Interactivity", artboardName: "BELL"),tab: .bell),
    TabItem(icon: RiveViewModel(fileName: "icons",
                                stateMachineName: "TIMER_Interactivity", artboardName: "TIMER"),tab:.timer),
    TabItem(icon: RiveViewModel(fileName: "icons",
                                stateMachineName: "USER_Interactivity", artboardName: "USER"),tab: .user)
]

enum Tab {
    case chat
    case search
    case bell
    case timer
    case user
}

