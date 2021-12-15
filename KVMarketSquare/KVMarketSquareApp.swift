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
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appData)
                .onAppear() {
                    // fix for bug where system is in dark mode but all toggles are off but it is still in dark mode
                    Utilities().overrideDisplayMode(appData.userInterfaceStyle)
                }
        }
    }
}
