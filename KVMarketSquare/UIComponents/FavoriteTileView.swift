//
//  FavoriteTileView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-13.
//

import SwiftUI

struct FavoriteTileView: View {
    let store: SellerAppData
    
    var body: some View {
        HStack {
            // Seller logo goes here
            potentialLogoImageView.frame(width: 36, height: 36)
            
            VStack {
                Text(store.displayName ?? "")
                    .horizontalAlignment(.leading)
                Text(store.city)
                    .font(.caption)
                    .horizontalAlignment(.leading)
            }
        }
        .padding(.vertical, 8)
    }
    
    var potentialLogoImageView: some View {
        if let logoImage = KVAsyncImage(url: store.merchantLogoURL) {
            return AnyView(logoImage)
        } else if let giftCardBusinessType = store.giftCardBusinessType, let gcImage = giftCardBusinessImage(businessDescription: giftCardBusinessType) {
            return AnyView(gcImage)
        } else if let sellerTypeImage = store.sellerType?.image {
            return AnyView(sellerTypeImage)
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private func giftCardBusinessImage(businessDescription: String) -> Image? {
        switch store.giftCardBusinessType {
        case "food_truck_cart", "grocery_market", "food_stores_convenience_stores_and_specialty_markets":
            return Image(systemName: "takeoutbag.and.cup.and.straw")
        case "clothing_and_accessories":
            return Image(systemName: "shirt")
        case "coffee_tea_shop":
            return Image(systemName: "takeoutbag.and.cup.and.straw")
        case "restaurants":
            return Image(systemName: "fork.knife")
        case "bar_club_lounge":
            return Image(systemName: "music.mic")
        case "bakery":
            return Image(systemName: "fork.knife")
        case "charitible_orgs":
            return Image(systemName: "person.3")
        case "medical_services_and_health_practitioners":
            return Image(systemName: "cross.circle")
        case "beauty_and_barber_shops":
            return Image(systemName: "comb")
        case "artists_supply_and_craft_shops":
            return Image(systemName: "paintpalette")
        case "computer_equipment_software_maintenance_repair_services":
            return Image(systemName: "laptopcomputer.trianglebadge.exclamationmark")
        default:
            return nil
        }
    }
}

struct FavoriteTileView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteTileView(store: SellerAppData.preview)
    }
}

struct KVAsyncImage: View {
    private let url: URL
    @State private var opacity: Double = 0
    @StateObject var loader = ImageLoader.shared
    
    init?(url: URL?) {
        guard let url = url else { return nil }
        self.url = url
    }
    
    var body: some View {
        Group {
            if let image = loader.cache[url] {
                Image(uiImage: image)
                .resizable()
                .scaledToFit()
            } else {
                Image(systemName: "pencil")
            }
        }.onAppear {
            if loader.cache[url] == nil {
                loader.load(url: url)
            }
        }
    }
}

import Combine
enum ImageError: Error {
    case badImage
}

class ImageLoader: ObservableObject {
    static let shared = ImageLoader()
    
    @Published var cache: [URL: UIImage] = [:]
    var cancelables = Set<AnyCancellable>()
    
    func load(url: URL) {
        // we first set a default image
        // else the sink will crash when trying
        // to access the hash
        cache[url] = UIImage(systemName: "pencil")!
        
        URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode,
                  let img = UIImage(data: data)
            else {
                throw ImageError.badImage
            }
            
            return img
        }
        .replaceError(with: UIImage(systemName: "pencil")! )
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self, url] value in
            self?.cache[url] = value
        })
        .store(in: &cancelables)
    }
}
