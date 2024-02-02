//
//  MenuItemModel.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 02/02/2024.
//

import Foundation
import RiveRuntime
struct MenuItem:Identifiable {
    var id = UUID()
    var icon:RiveViewModel
    var text:String
    var menu:SelectedMenu
}


var menuItems = [
    MenuItem(icon: RiveViewModel(fileName: "icons",
                                 stateMachineName: "HOME_interactivity", artboardName: "HOME"),text: "Home",menu:.home),
    MenuItem(icon: RiveViewModel(fileName: "icons",
                                 stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH"),text: "Search",menu:.search),
    MenuItem(icon: RiveViewModel(fileName: "icons",
                                 stateMachineName: "STAR_Interactivity", artboardName: "LIKE/STAR"),text: "Favourites",menu:.favourites),
    MenuItem(icon: RiveViewModel(fileName: "icons",
                                 stateMachineName: "CHAT_Interactivity", artboardName: "CHAT"),text: "Help",menu:.help)

]
var menuItems2 = [
    MenuItem(icon: RiveViewModel(fileName: "icons",
                                 stateMachineName: "BELL_Interactivity", artboardName: "BELL"),text: "History",menu:.history),
    MenuItem(icon: RiveViewModel(fileName: "icons",
                                 stateMachineName: "TIMER_Interactivity", artboardName: "TIMER"),text: "Notifications",menu:.notifications),
]

