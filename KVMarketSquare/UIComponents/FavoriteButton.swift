//
//  FavoriteButton.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-14.
//

import SwiftUI

struct FavoriteButton: View {
    @EnvironmentObject private var appData: AppData
    @Environment(\.colorScheme) var currentMode
    var sellerStore: SellerAppData
    
    var body: some View {
        Button(
            action: {
                if $appData.favoriteShops.wrappedValue.contains(sellerStore) {
                    appData.favoriteShops.remove(sellerStore)
                } else {
                    appData.favoriteShops.insert(sellerStore)
                }
                
            }, label: {
                Image(systemName: $appData.favoriteShops.wrappedValue.contains(sellerStore) ? "heart.fill" : "heart")
                    .renderingMode(.template)
                    .foregroundColor(currentMode == .dark ? .white : .black)
            }
        )
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(sellerStore: SellerAppData.preview)
    }
}
