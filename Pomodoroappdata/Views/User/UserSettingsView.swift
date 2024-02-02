//
//  UserSettingsView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 02/02/2024.
//

import SwiftUI
import StoreKit

struct UserSettingsView: View {
    @State var isNotifications:Bool = true
    @Environment(\.requestReview) var requestReview

    var body: some View {
        ZStack {
            VStack {
                Section {
                    List {
                        Section {
                            Label("Billing", systemImage:"person")
                            Label("Rate our app",systemImage: "star")
                        }
                          
                        Section {
                            HStack {
                                Image(systemName: "bell")
                                Toggle("Notifications", isOn: $isNotifications)
                                    .sensoryFeedback(.success, trigger: isNotifications)
                            }
                            HStack {
                                Image(systemName: "heart")
                                Toggle("Apple health", isOn: $isNotifications)
                                    .sensoryFeedback(.success, trigger: isNotifications)
                            }
                            HStack {
                                Image(systemName: "bell")
                                Toggle("Notifications", isOn: $isNotifications)
                                    .sensoryFeedback(.success, trigger: isNotifications)
                            }
                        }
                        
                        Section {
                            Label("About us",systemImage: "questionmark")
                                
                            Label("Recommend",systemImage: "hand.thumbsup")
                            Label("Rate us",systemImage: "star")
                                .onTapGesture {
                                    requestReview()
                                }
                            Link(destination: URL(string:"https://timely-ios-web.vercel.app")!, label: {
                                Label("Website",systemImage: "link")

                            })


                            
                        }

                    }
                }
                
                
                  
                
            }
        }
    }
}

#Preview {
    UserSettingsView(isNotifications: true)
}
