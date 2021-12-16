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
                .navigationTitle(title)
        }
    }
    
    func horizontalAlignment(_ alignment: Alignment) -> some View {
        HStack {
            if alignment == .trailing {
                Spacer()
            }
            
            self
            
            if alignment == .leading {
                Spacer()
            }
        }
    }
}


enum Alignment {
    case leading, trailing
}
