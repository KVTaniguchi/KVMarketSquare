//
//  IconHeaderText.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-16.
//

import SwiftUI

enum IconType {
    case address, phone, email, web
    
    var iconImage: Image {
        switch self {
        case .address:
            return Image(systemName: "building.2.crop.circle")
        case .phone:
            return Image(systemName: "phone.circle")
        case .email:
            return Image(systemName: "envelope.circle")
        case .web:
            return Image(systemName: "globe")
        }
    }
}

struct IconHeaderText: View {
    var type: IconType
    var text: String
    var font: Font = .caption
    
    var body: some View {
        HStack {
            type.iconImage
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.key(.tint))
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(font)
        }
    }
}

struct IconHeaderText_Previews: PreviewProvider {
    static var previews: some View {
        IconHeaderText(type: .phone, text: "")
    }
}
