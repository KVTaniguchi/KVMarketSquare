//
//  HomeView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            // Switch to list / map
                        }, label: {
                            Image(systemName: "list.bullet")
                        }
                    )
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
