//
//  SideMenuRow.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 02/02/2024.
//

import SwiftUI

struct SideMenuRow: View {
    var menuItem:MenuItem
    @Binding var selectedMenu:SelectedMenu
    var body: some View {
        HStack(spacing:14) {
            menuItem.icon.view()
                .frame(width:34,height:34)
                .opacity(0.6)
            Text(menuItem.text)
        }
        .frame(maxWidth:.infinity,alignment:.leading)
    .padding(12)
    .background(RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
        .fill(.blue)
        .frame(maxWidth:selectedMenu == menuItem.menu ? .infinity : 0)
        .frame(maxWidth:.infinity,alignment:.leading)
    )
    .background(Color("Background 2"))
    .onTapGesture {
        try? menuItem.icon.setInput("active",value: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            try? menuItem.icon.setInput("active",value: false)
        }
        withAnimation {
            selectedMenu = menuItem.menu
        }
    }
    }
}

#Preview {
    SideMenuRow(menuItem: menuItems[0],selectedMenu:.constant(.home))
}
