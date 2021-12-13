import SwiftUI

struct URLLookupPayload: Codable {
    let userSites: [SellerIdentifier]

    enum CodingKeys: String, CodingKey {
        case userSites = "user_sites"
    }
}

struct SellerIdentifier: Codable {
    let userID, siteID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case siteID = "site_id"
    }
}

struct SellerStore {
    let userId: String
    let siteId: String
    var url: URL?
}

// POST
//https://www.weebly.com/app/website/api/v1/sites/urls

struct StoreURLFetcher {
    func fetch() {
        
    }
}

// response
//{
//  "119203630": { user id
//    "271265949680067218": { site id
//      "url": "https://karibu-grocery-deli.square.site" url
//    }
//  },
//  "124050880": {
//    "623544097567863026": {
//      "url": "https://x2-pastries.square.site"
//    }
//  }
//}

struct SellerURLsResponse {
    let users: [User]
    
    struct User {
        let userId: String
        let site: Site
        
        struct Site {
            let siteId: String
            let url: URL
        }
    }
}
