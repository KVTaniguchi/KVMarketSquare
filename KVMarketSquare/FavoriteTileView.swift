//
//  FavoriteTileView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import SwiftUI

struct FavoriteTileView: View {
    let name: String
    
    var body: some View {
        Text(name)
    }
}

struct FavoriteTileView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTileView(name: "hello")
    }
}
