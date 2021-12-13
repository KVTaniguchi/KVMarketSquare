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
                .addNavigationView(title: Localization.key(.TabHomeTitle))
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(Localization.key(.TabHomeTitle))
                }.tag(0)
            SettingsView()
                .addNavigationView(title: Localization.key(.TabSettingsTitle))
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text(Localization.key(.TabSettingsTitle))
                }.tag(1)
        }
        .tint(.black)
    }
}
