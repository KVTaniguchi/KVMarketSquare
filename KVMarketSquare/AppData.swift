//
//  AppData.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import Foundation

class AppData: ObservableObject {
    @Published(key: "favoriteShops") var favoriteShops: Set<SellerAppData> = []
    
    @Published(key: "isAutomaticColorScheme") var isAutomaticColorScheme: Bool = true
    @Published(key: "isDarkmode") var isDarkMode: Bool = false
    @Published(key: "userInterfaceStyle") var userInterfaceStyle: UserInterfaceStyle = UserInterfaceStyle.system
}

struct SellerAppData: Identifiable, Hashable, Codable {
    let id: String
    let siteId: String
    let userId: String
    let city: String
    let displayName: String?
    
    init(
        siteId: String,
        userId: String,
        city: String,
        displayName: String? = nil
    ) {
        self.siteId = siteId
        self.userId = userId
        self.city = city
        self.displayName = displayName
        self.id = userId
    }
    
    static var preview = SellerAppData(
        siteId: "",
        userId: "",
        city: "",
        displayName: ""
    )
}
