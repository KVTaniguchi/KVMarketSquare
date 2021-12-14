//
//  Localization.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import Foundation

extension String {
    func i18n() -> String {
        if self == NSLocalizedString(self, comment: "") {
            if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
               let bundle = Bundle(path: path) {
                return bundle.localizedString(forKey: self, value: self, table: nil)
            }
        }
        return NSLocalizedString(self, comment: "")
    }
}

enum Localization: String {
    static func key(_ key: Localization) -> String {
        key.rawValue.i18n()
    }
    
    // Main
    case TabHomeTitle, TabSettingsTitle
    
    // Home
    case HomeEmptyTitle, HomeEmptyDescription, ShopListTitle
    
    // Search
    case SearchViewTitle, SearchFieldTitle
}
