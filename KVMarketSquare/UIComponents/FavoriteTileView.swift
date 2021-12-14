//
//  FavoriteTileView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import SwiftUI

struct FavoriteTileView: View {
    let store: SellerAppData
    
    var body: some View {
        HStack {
            // Seller logo goes here
            Circle()
                .foregroundColor(.black)
                .frame(width: 36, height: 36)
            
            VStack {
                Text(store.displayName ?? "")
                    .horizontalAlignment(.leading)
                Text(store.city)
                    .font(.caption)
                    .horizontalAlignment(.leading)
            }
        }
        .padding(.vertical, 8)
    }
}

struct FavoriteTileView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTileView(store: SellerAppData.preview)
    }
}
