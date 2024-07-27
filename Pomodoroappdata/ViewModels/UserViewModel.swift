//
//  UserViewModel.swift
//  Pomodoroappdata
//
//  Created by Ali Siddique on 25/06/2024.
//



import Foundation
import SwiftUI
import RevenueCat

class UserViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    
    init() {
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            
                
            self.isSubscriptionActive = customerInfo?.entitlements.all["pro"]?.isActive == true
            print(self.isSubscriptionActive)
            
            
        }
    }
    
}
