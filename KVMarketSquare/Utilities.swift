//
//  Utilities.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-14.
//

import SwiftUI

class Utilities {
    var userInterfaceStyle: ColorScheme? = .dark

    func overrideDisplayMode(_ appDataUserInterfaceStyle: UserInterfaceStyle) {
        var userInterfaceStyle: UIUserInterfaceStyle

        if appDataUserInterfaceStyle == UserInterfaceStyle.dark {
            userInterfaceStyle = .dark
        } else if appDataUserInterfaceStyle == UserInterfaceStyle.light {
            userInterfaceStyle = .light
        } else {
            userInterfaceStyle = .unspecified
        }
        
        if let window = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).first(where: { $0.isKeyWindow }) {
            UIView.transition (with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }, completion: nil)
        }
    }
}

enum UserInterfaceStyle: String, Codable {
    case system
    case dark
    case light
}
