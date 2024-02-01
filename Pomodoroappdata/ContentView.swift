//
//  ContentView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/01/2024.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    @State private var selectedTab: Tab = .chat
    @State var isOpen = false
    let button  = RiveViewModel(fileName:"menu_button",stateMachineName: "State Machine",autoPlay: false)
    
    var body: some View {
        ZStack {
     
            button.view()
                .frame(width: 36,height:36)
                .mask(Circle())
                .shadow(color:Color.blue.opacity(0.4),radius: 5,x:0,y:5)
                .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading)
                .padding()
                .onTapGesture {
                    try? button.setInput("isOpen", value: isOpen) 
                
                    isOpen.toggle()
                }

            TabBar(selectedTab: $selectedTab)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(PomodoroModel())
}
