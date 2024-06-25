//
//  OnboardingView.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/06/2024.
//

import SwiftUI


struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                WelcomeView()
                    .tag(0)
                NotificationPermissionView()
                    .tag(1)
                Paywall()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
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
                }
                
                Spacer()
                
                if currentPage < 2 {
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
                        Text("Skip")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 40)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                }
            }
            .padding()
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {
                let size = $0.size
                
                Image("Spline")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -60)
                    .frame(width: size.width, height: size.height)
                    .ignoresSafeArea()
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(
                        colors: [
                            .white,
                            .white,
                            .white,
                            .white,
                            .white.opacity(0.9),
                            .white.opacity(0.6),
                            .white.opacity(0.2),
                            .clear,
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            }
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Welcome to Timely!")
                    .font(.title.bold())
                Text("Start being productive today.")
                    .font(.title3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
    }
}

struct NotificationPermissionView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {
                let size = $0.size
                
                Image("Spline")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -60)
                    .frame(width: size.width, height: size.height)
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(
                        colors: [
                            .white,
                            .white,
                            .white,
                            .white,
                            .white.opacity(0.9),
                            .white.opacity(0.6),
                            .white.opacity(0.2),
                            .clear,
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            }
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Enable Notifications")
                    .font(.title.bold())
                Text("Allow updates for when to take a break and when to start work!")
                    .font(.title3)
                
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
import RevenueCatUI
struct Paywall: View {
    @State
      var displayPaywall = false
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {
                let size = $0.size
                
                Image("Spline")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -60)
                    .frame(width: size.width, height: size.height)
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(
                        colors: [
                            .white,
                            .white,
                            .white,
                            .white,
                            .white.opacity(0.9),
                            .white.opacity(0.6),
                            .white.opacity(0.2),
                            .clear,
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            }
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Unlock Full Access")
                    .font(.title.bold())
                Text("Subscribe to get unlimited access to all features.")
                    .font(.title3)
                
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
        }
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
