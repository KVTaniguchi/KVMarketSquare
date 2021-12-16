//
//  StoreServiceSection.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-16.
//

import SwiftUI

enum StoreServiceType: CaseIterable {
    case delivery, pickup, curbside, schedulePickup, preparedStatus
    
    var title: String {
        switch self {
        case .delivery:
            return Localization.key(.ServiceDevlieryTitle)
        case .pickup:
            return Localization.key(.ServicePickupTitle)
        case .curbside:
            return Localization.key(.ServiceCurbesideTitle)
        case .schedulePickup:
            return Localization.key(.ServiceScheduleTitle)
        case .preparedStatus:
            return Localization.key(.ServicePreparedTitle)
        }
    }
    
    func enabledIcon(store: SellerAppData) -> Image {
        var isEnabled: Bool = false
        switch self {
        case .delivery:
            isEnabled = store.deliveryEnabled == "1"
        case .pickup:
            isEnabled = store.pickupEnabled == "1"
        case .curbside:
            isEnabled = store.curbsidePickupEnabled == "1"
        case .schedulePickup:
            isEnabled = store.schedulePickupEnabled == "1"
        case .preparedStatus:
            isEnabled = store.preparedStatusEnabled == "1"
        }
        
        return Image(systemName: isEnabled ? "checkmark.square" : "square")
    }
}

struct StoreServiceSection: View {
    var store: SellerAppData
    
    var body: some View {
        VStack {
            Text(Localization.key(.ServiceSectionTitle))
                .bold()
                .horizontalAlignment(.leading)
            
            ForEach(StoreServiceType.allCases, id: \.self) { type in
                HStack {
                    Text("● \(type.title)")
                        .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                    
                    type.enabledIcon(store: store)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                    
                    Spacer()
                }
            }
        }
    }
}

struct StoreServiceSection_Previews: PreviewProvider {
    static var previews: some View {
        StoreServiceSection(store: SellerAppData.preview)
    }
}
