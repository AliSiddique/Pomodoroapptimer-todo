//
//  SideMenuModel.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 02/02/2024.
//

import Foundation
import RiveRuntime
struct SideMenuItem : Identifiable {
    var id = UUID()
    var text:String
    var icon:RiveViewModel
}


enum SelectedMenu:String {
    case home
    case search
    case favourites
    case help
    case history
    case notifications
    case darkMode
}
