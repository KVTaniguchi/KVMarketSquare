//
//  Favorites.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import Foundation

class AppData: ObservableObject {
    // this should be of type some link to a shop identifier
    @Published(key: "favortieShops") var favoriteShops: Set<SellerAppData> = []
}

struct SellerAppData: Identifiable, Hashable, Codable {
    let id: String
    let siteId: String
    let userId: String
    let displayName: String?
    
    init(
        siteId: String,
        userId: String,
        displayName: String? = nil
    ) {
        self.siteId = siteId
        self.userId = userId
        self.displayName = displayName
        self.id = userId
    }
}
