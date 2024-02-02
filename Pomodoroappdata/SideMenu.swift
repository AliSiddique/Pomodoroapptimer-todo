//
//  SideMenu.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 01/02/2024.
//

import SwiftUI
import RiveRuntime

struct SideMenu: View {
    @State var selectedMenu:SelectedMenu = .home
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .font(.title2)
                VStack {
                    Text("Ali")
                        .font(.title2)
                    Text("Caption")
                        .font(.caption2)
                }
                Spacer()
            }
            .padding()
            Text("Browse")
                .padding(.top,20)
                .padding(.horizontal,20)
                .font(.subheadline)
                .frame(maxWidth:.infinity,alignment: .leading)
            VStack(alignment:.leading,spacing:0) {
                ForEach(menuItems) { menuItem in
                    Rectangle()
                        .frame(height:1)
                        .opacity(0.3)
                        .padding(.horizontal,16)
                    SideMenuRow(menuItem: menuItem,selectedMenu: $selectedMenu)
                }
            }
            .padding(8)
            
            Text("History")
                .padding(.top,20)
                .padding(.horizontal,20)
                .font(.subheadline)
                .frame(maxWidth:.infinity,alignment: .leading)
            VStack(alignment:.leading,spacing:0) {
                ForEach(menuItems2) { menuItem in
                    Rectangle()
                        .frame(height:1)
                        .opacity(0.3)
                        .padding(.horizontal,16)
                    SideMenuRow(menuItem: menuItem,selectedMenu: $selectedMenu)
                }
            }
            Spacer()
        
        }
            .foregroundColor(.white)
            .frame(maxWidth: 288,maxHeight:.infinity)
            .background(Color("Background 2"))
            .mask(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        .frame(maxWidth:.infinity,alignment: .leading)
        
    }
}

#Preview {
    SideMenu()
}






