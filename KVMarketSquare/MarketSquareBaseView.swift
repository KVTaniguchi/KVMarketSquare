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
        
        // showing search sheet
        //  - selecting an item pops another list sheet with store search results
        
        //  - selecting an store item drops back down to bottom sheet and shows store buttons, circular arranged in a collection view grid, but list for now is fine
        
        // area showing list of selected stores - can be updated

        List {
            // takes in a list store ids and executes a search against them
        }
    }
}
