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
        UIApplication.shared.keyWindow?.overrideUserInterfaceStyle =  userInterfaceStyle
    }
}

enum UserInterfaceStyle: String, Codable {
    case system
    case dark
    case light
}
