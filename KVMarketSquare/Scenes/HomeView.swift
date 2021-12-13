//
//  HomeView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import SwiftUI

struct HomeView: View {
    @State private var showingSearchSheet = false
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        contentView
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        showingSearchSheet.toggle()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                    }
                )
            }
        }
        .sheet(isPresented: $showingSearchSheet) {
            SearchView() { store in
                
            }.environmentObject(appData)
        }
    }
    
    private var contentView: some View {
        if appData.favoriteShops.count == 0 {
            return AnyView(emptyView)
        }
        return AnyView(shopsListView)
    }
    
    private var emptyView: some View {
        VStack {
            Image(systemName: "tray.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.1)
            
            Text(Localization.key(.HomeEmptyTitle))
                .bold()
                .padding(.top, 16)
            Text(Localization.key(.HomeEmptyDescription))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
    }
    
    private var shopsListView: some View {
        List {
            ForEach(Array(appData.favoriteShops)) { store in
                NavigationLink {
                    StoreWebView(store: store)
                } label: {
                    FavoriteTileView(name: store.displayName ?? store.userId)
                }
            }
        }
    }
}

struct StoreWebView: View {
    let store: SellerAppData
    
    var body: some View {
        Text("store view for \(store.displayName ?? "")\n\(store.userId)\n\(store.siteId)") // todo load the store here
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
