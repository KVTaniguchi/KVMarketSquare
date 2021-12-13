//
//  FoundationView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import SwiftUI

struct FoundationView: View {

    var body: some View {
        TabView {
            MarketSquareBaseView()
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Shop")
            }
            FavoritesView()
            .tabItem {
                Image(systemName: "heart")
                Text("Favorites")
            }
        }
    }
}
