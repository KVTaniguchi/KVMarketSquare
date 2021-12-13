//
//  View.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-13.
//

import SwiftUI

extension View {
    func addNavigationView(title: String) -> some View {
        NavigationView {
            self
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(title)
        }
    }
}
