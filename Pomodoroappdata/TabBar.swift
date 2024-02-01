//
//  TabBar.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 31/01/2024.
//

import SwiftUI
import RiveRuntime

struct TabBar: View {
    @Binding var selectedTab: Tab
  

    var body: some View {
        switch selectedTab {
              case .chat:
                  Text("Tab 1 content")
                  // You can replace this with the content of your first tab
        case .search:
                  Text("Tab 2 content")
                  // You can replace this with the content of your second tab
              case .bell:
                  Text("Tab 3 content")
                  // You can replace this with the content of your third tab
        case .timer:
            Text("d")
        case .user:
            Text("D")
        }
        VStack {
            Spacer()
            HStack {
                    content

            }
            .padding(12)
            .background(Color.teal)
            .mask(RoundedRectangle(cornerRadius: 20.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .overlay(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .stroke(.linearGradient(colors: [Color.white.opacity(0.6),Color.white.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .padding(.horizontal,24)
        }
    
    }
    var content:some View {
        ForEach(tabItems) { tab in
            Button {
                try? tab.icon.setInput("active",value: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    try? tab.icon.setInput("active",value: false)
                }
                withAnimation {
                    selectedTab = tab.tab
                }
            } label: {
                tab.icon.view()
                    .frame(height:36)
                    .opacity(selectedTab == tab.tab ? 1 : 0.5)
                    .background(
                        
                        VStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.red)
                                .frame(width:20,height:4)
                                .offset(y:-4)
                                .opacity(selectedTab == tab.tab ? 1:0)
                            Spacer()
                        }
                    )
                }
        }
    }
}
#Preview {
    TabBar(selectedTab: .constant(.chat))
}

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
