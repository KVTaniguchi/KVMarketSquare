//
//  FavoritesView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: Favorites
    
    var body: some View {
        NavigationView {
            VStack {
                if favorites.shops.count == 0 {
                    Text("You don't have any favorites yet")
                } else {
                    ForEach(favorites.shops, id: \.self) { shop in
                        Text(shop)
                    }
                }
            }
            .navigationTitle(Text("Favorites"))
        }
    }
}
