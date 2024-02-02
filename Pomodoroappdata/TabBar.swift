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
  
    @Binding var isOpen:Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                    content

            }
            .padding(12)
            .background(Color("Background 2"))
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
    TabBar(selectedTab: .constant(.chat),isOpen: .constant(true))
}





