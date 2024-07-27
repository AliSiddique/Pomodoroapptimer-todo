//
//  ShieldConfigurationExtension.swift
//  shield-config
//
//  Created by Ali Siddique on 12/07/2024.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration()
    }
//    override func configuration(shielding application: Application) -> ShieldConfiguration {
//            // Customize the shield as needed for applications.
//            ShieldConfiguration(
//                backgroundColor: .tintColor,
//                title: ShieldConfiguration.Label(text: "Do you really need to use this app?", color: .label),
//                subtitle: ShieldConfiguration.Label(text: "Like are you sure?", color: .systemBrown),
//                primaryButtonLabel: ShieldConfiguration.Label(text: "Unlock", color: .label),
//                primaryButtonBackgroundColor: .systemGreen,
//                secondaryButtonLabel: ShieldConfiguration.Label(text: "Don't unlock.", color: .label)
//            )
//        }
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(
            backgroundColor: .systemCyan,
            title: ShieldConfiguration.Label(text: "Get back to work!", color: .label),
            subtitle: ShieldConfiguration.Label(text: "You can come back later", color: .systemBrown)
//            primaryButtonLabel: ShieldConfiguration.Label(text: "Unlock", color: .label),
//            primaryButtonBackgroundColor: .systemGreen,
//            secondaryButtonLabel: ShieldConfiguration.Label(text: "Don't unlock.", color: .label)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration(
            backgroundColor: .systemCyan,
            title: ShieldConfiguration.Label(text: "Do you really need to use this app?", color: .label),
            subtitle: ShieldConfiguration.Label(text: "Like are you sure?", color: .systemBrown),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Unlock", color: .label),
            primaryButtonBackgroundColor: .systemGreen,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Don't unlock.", color: .label)
        )    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration(
            backgroundColor: .systemCyan,
            title: ShieldConfiguration.Label(text: "Do you really need to use this app?", color: .label),
            subtitle: ShieldConfiguration.Label(text: "Like are you sure?", color: .systemBrown),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Unlock", color: .label),
            primaryButtonBackgroundColor: .systemGreen,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Don't unlock.", color: .label)
        )    }
}
