//
//  OnboardingView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/06/2024.
//

import SwiftUI


import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Image
                Image("Wallpaper 2")
                    .resizable()
                
                    .overlay(Color.black.opacity(0.4))
                    .ignoresSafeArea()

                VStack {
                    // TabView for different onboarding pages
                    TabView(selection: $currentPage) {
                        WelcomeView()
                            .tag(0)
                        NotificationPermissionView()
                            .tag(1)
                        ScreenTimePermissionView()
                            .tag(2)
                        Paywall()
                            .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: geometry.size.height * 0.8)

                    // Navigation Buttons
                    HStack {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                Text("Back")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .frame(width: 100, height: 40)
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }
                        } else {
                            Spacer().frame(width: 100)
                        }
                        
                        Spacer()
                        
                        if currentPage < 3 {
                            Button(action: {
                                withAnimation {
                                    currentPage += 1
                                }
                            }) {
                                Text("Next")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        } else {
                            Button(action: {
                                isOnboarding = true
                            }) {
                                Text("Get Started")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(25)
                    .padding()
                }
            }
        }
    }
}

// Template for individual views
struct OnboardingPageView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            content
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
    }
}

struct WelcomeView: View {
    var body: some View {
   
           
            VStack(alignment: .leading) {
                    Spacer()
                    Text("Welcome to Timely!")
                        .font(.title.bold())
                    Text("Start being productive today.")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
            .padding(20)
        
      
    }
}

struct NotificationPermissionView: View {
    var body: some View {
          
            
            VStack(alignment: .leading) {
                Spacer()
                Text("Enable Notifications")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text("Allow updates for when to take a break and when to start work!")
                    .font(.title3)
                    .foregroundStyle(.white)

                Button(action: {
                    requestNotificationPermission()
                }) {
                    Text("Enable Notifications")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                
              
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
    
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
}
import SwiftUI
import FamilyControls

struct ScreenTimePermissionView: View {
    let center = AuthorizationCenter.shared
    @State private var isRequesting = false

    var body: some View {
      
            
            VStack(alignment: .leading) {
                Spacer()
                Text("Allow access to screentime")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Text("Allow access to limit apps when you are studying!")
                    .font(.title3)
                    .foregroundStyle(.white)

                
                Button {
                    Task {
                        await requestScreenTime()
                    }
                }label: {
                    Text(isRequesting ? "Requesting..." : "Enable Screen Time")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRequesting ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(isRequesting)
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
    
    
    private func requestScreenTime() async {
        guard !isRequesting else { return }
        isRequesting = true
        
        do {
            try await center.requestAuthorization(for: .individual)
            print("Screen time authorization successful")
        } catch {
            print("Failed to get authorization: \(error)")
        }
        
        isRequesting = false
    }
}
import RevenueCatUI
import FamilyControls
struct Paywall: View {
    @State var displayPaywall = false
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Spacer()
            Text("Unlock Full Access")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            Text("Subscribe to get unlimited access to all features.")
                .font(.title3)
                .foregroundStyle(.white)
            
            
            Button(action: {
                displayPaywall = true
            }) {
                Text("Subscribe Now")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .sheet(isPresented: self.$displayPaywall) {
            PaywallView(displayCloseButton: true)
        }
    }
       
}
    


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
