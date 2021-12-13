//
//  MarketSquareBaseView.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/12/21.
//

import SwiftUI


struct FoundationView: View {
    @State private var showingSearchSheet = false
    
    // store loading task
    
    var body: some View {
        // ui element at top, when tapped, the search feature is shown in a sheet
        VStack {
            Button("Find stores") {
                showingSearchSheet.toggle()
            }
            .padding()
            .sheet(isPresented: $showingSearchSheet) {
                SearchView() { store in
                    
                }
            }
        }

        List {
            // takes in a list store ids and executes a search against them
        }
    }
}

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

struct SavedStores {
    
}

struct SellerStore {
    let userId: String
    let siteId: String
    var url: URL?
}

// POST
//https://www.weebly.com/app/website/api/v1/sites/urls

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
