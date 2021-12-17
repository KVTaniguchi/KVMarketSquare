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
    @Published(key: "isLettingItSnow") var isLettingItSnow: Bool = true
    
    @Published var snowScene = BetterSnowFall()
}

struct SellerAppData: Identifiable, Hashable, Codable {
    let id: String
    let siteId: String
    let userId: String
    let pickupEnabled: String
    let preparedStatusEnabled: String
    let schedulePickupEnabled: String
    let deliveryEnabled: String
    let curbsidePickupEnabled: String
    let street: String
    let street2: String
    let city: String
    let postalCode: String
    let region: String
    let countryCode: CountryCode
    let phone: String?
    let email: String?
    let storeLatLon: String
    let displayName: String?
    let merchantLogoURL: URL?
    let giftCardBusinessType: String?
    let sellerType: SellerType?
    let addressString: String
    
    init(store: SellerSearchResultViewModel) {
        self.siteId = store.siteId
        self.userId = store.userId
        self.pickupEnabled = store.pickupEnabled
        self.preparedStatusEnabled = store.preparedStatusEnabled
        self.schedulePickupEnabled = store.schedulePickupEnabled
        self.deliveryEnabled = store.deliveryEnabled
        self.curbsidePickupEnabled = store.curbsidePickupEnabled
        self.street = store.street
        self.street2 = store.street2
        self.city = store.city
        self.postalCode = store.postalCode
        self.region = store.region
        self.countryCode = store.countryCode
        self.phone = store.phone
        self.email = store.email
        self.storeLatLon = store.storeLatLon
        self.displayName = store.displayName
        self.id = store.userId
        self.merchantLogoURL = store.merchantLogoURL
        self.giftCardBusinessType = store.giftCardBusinessType
        self.sellerType = store.sellerType
        self.addressString = [store.street, store.street2, store.city, store.postalCode, store.region].joined(separator: " ")
    }
    
    static var preview = SellerAppData(store: SellerSearchResultViewModel(store: Datum.preview))
}
