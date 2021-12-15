//
//  NavBackButton.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-14.
//

import SwiftUI

struct NavBackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(
            action: {
                dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .renderingMode(.template)
                    .tint(.blue)
            }
        )
    }
}

struct NavBackButton_Previews: PreviewProvider {
    static var previews: some View {
        NavBackButton()
    }
}
