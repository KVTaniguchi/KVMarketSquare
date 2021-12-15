//
//  NavBackButton.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-14.
//

import SwiftUI

enum NavBackType {
    case back, close
}

struct NavBackButton: View {
    @Environment(\.dismiss) var dismiss
    var type: NavBackType = .back
    var dismissAction: DismissAction?
    
    var body: some View {
        Button(
            action: {
                if let dismissAction = dismissAction {
                    dismissAction()
                } else {
                    dismiss()
                }
            }, label: {
                Image(systemName: type == .back ? "chevron.left" : "xmark")
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
