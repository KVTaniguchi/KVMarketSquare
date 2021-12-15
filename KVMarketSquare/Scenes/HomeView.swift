//
//  HomeView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appData: AppData
    @State private var showingSearchSheet = false
    @State private var selectedStore: SellerAppData?
    
    var body: some View {
        contentView
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        showingSearchSheet.toggle()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .renderingMode(.template)
                            .tint(.blue)
                    }
                )
            }
        }
        .fullScreenCover(isPresented: $showingSearchSheet) {
            SearchView() { _ in }.environmentObject(appData)
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
            Section {
                ForEach(Array(appData.favoriteShops)) { store in
                    Button {
                        selectedStore = store
                    } label: {
                        FavoriteTileView(store: store)
                    }
                }
                .onDelete { offsets in
                    appData.favoriteShops.delete(at: offsets)
                }
                .listRowSeparator(.hidden)

            } header: {
                Text(Localization.key(.ShopListTitle))
                    .font(.body)
                    .bold()
                    .textCase(.none)
            }
        }
        .fullScreenCover(item: $selectedStore) { store in
            StoreWebView(store: store)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
