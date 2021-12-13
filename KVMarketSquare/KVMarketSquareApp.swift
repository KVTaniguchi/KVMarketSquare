//
//  KVMarketSquareApp.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/3/21.
//

import SwiftUI

@main
struct KVMarketSquareApp: App {
    @StateObject var favorites = Favorites()

    var body: some Scene {
        WindowGroup {
            FoundationView()
                .environmentObject(favorites)
        }
    }
}
