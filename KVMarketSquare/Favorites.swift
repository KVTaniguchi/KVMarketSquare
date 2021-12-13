//
//  Favorites.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import Foundation

class Favorites: ObservableObject {
    // this should be of type some link to a shop identifier
    @Published var shops: [String] = []
}
