//
//  MainTabView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .addNavigationView(title: "Home")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(0)
            SettingsView()
                .addNavigationView(title: "Settings")
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }.tag(1)
        }
    }
}
