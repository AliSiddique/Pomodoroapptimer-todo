//
//  SideMenu.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 01/02/2024.
//

import SwiftUI
import RiveRuntime

struct SideMenu: View {
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
            Spacer()
        }
            .foregroundColor(.white)
            .frame(maxWidth: 288,maxHeight:.infinity)
            .background(.black)
            .mask(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        .frame(maxWidth:.infinity,alignment: .leading)
        
    }
}

#Preview {
    SideMenu()
}


struct SideMenuItem : Identifiable {
    var id = UUID()
    var text:String
    var icon:RiveViewModel
}


//var sideMenuItems = [
//    
//    
//]
