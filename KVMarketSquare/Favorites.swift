//
//  Favorites.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import Foundation

class AppData: ObservableObject {
    // this should be of type some link to a shop identifier
    @Published var favoriteShops: [String] = ["hi", "bye"]
}
