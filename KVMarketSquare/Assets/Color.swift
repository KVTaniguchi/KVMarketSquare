//
//  Color.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-15.
//

import SwiftUI

extension Color {
    
    enum Key: String {
        case tint, background
    }
    
    static func key(_ key: Key) -> Color {
        Color(key.rawValue.capitalizeFirstLetter())
    }
    
    static func uiColor(_ key: Key) -> UIColor {
        UIColor(named: key.rawValue.capitalizeFirstLetter()) ?? .black
    }
}
