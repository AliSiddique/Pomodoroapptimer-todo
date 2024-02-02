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
            Color("Background 2").ignoresSafeArea()
           SideMenu()
                .opacity(isOpen ? 1 : 0)
                .offset(x:isOpen ? 0 : -300)
                .rotation3DEffect(
                    .degrees(isOpen ? 0 : 30),
                                          axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            Group {
                switch selectedTab {
                case .chat:
                    HomeView()
                    
                    
                    // You can replace this with the content of your first tab
                case .search:
                    Text("Tab 1 contesdoijfifsoidofijsodijjoidfoijdoisfjdsjoidt")                          // You can replace this with the content of your second tab
                case .bell:
                    Text("Tab 1 contesdoijfifsoidofijsodijjoidfoijdoisfjdsjoidt")                          // You can replace this with the content of your third tab
                case .timer:
                    Text("Tab 1 contesdoijfifsoidofijsodijjoidfoijdoisfjdsjoidt")      case .user:
                    UserSettingsView()
                        
                }
                   
            }
            .background(.teal)
            
            .rotation3DEffect(
                .degrees(isOpen ? 30 : 0),axis:(x:0,y:-1,z:0)
            )
            
            .mask(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            .offset(x:isOpen ? 265 : 0)
            .scaleEffect(isOpen ? 0.9 : 1)
            .ignoresSafeArea()
            button.view()
                .frame(width: 36,height:36)
                .mask(Circle())
                .shadow(color:Color.blue.opacity(0.4),radius: 5,x:0,y:5)
                .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading)
                .padding()
                .onTapGesture {
                    try? button.setInput("isOpen", value: isOpen) 
                    withAnimation(.spring(response:0.5, dampingFraction: 0.7)) {
                        isOpen.toggle()

                    }
                }
              

            TabBar(selectedTab: $selectedTab,isOpen:$isOpen)
                .rotation3DEffect(
                    .degrees(isOpen ? 30 : 0),axis:(x:0,y:-1,z:0)
                )
                
                .mask(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                .offset(x:isOpen ? 265 : 0)
                .scaleEffect(isOpen ? 0.9 : 1)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(PomodoroModel())
}

