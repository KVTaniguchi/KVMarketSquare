//
//  HomeView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import SwiftUI

struct HomeView: View {
    @State private var showingSearchSheet = false
    
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
                
            }
        }
    }
    
    private var contentView: some View {
        // have switch of number of saved stores here
        VStack {
            Text("Empty State goes here")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
