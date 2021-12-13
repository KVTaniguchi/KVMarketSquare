//
//  KVMarketSquareApp.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/3/21.
//

import SwiftUI

@main
struct KVMarketSquareApp: App {
    @StateObject var appData = AppData()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appData)
        }
    }
}
