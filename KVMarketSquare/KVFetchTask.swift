import Foundation
import Combine
import CoreLocation
import SwiftUI

enum HTTPError: LocalizedError {
    case statusCode
}

struct SellerSearchResultViewModel: Identifiable {
    let displayName: String
    let userId: String
    let siteId: String
    let pickupEnabled: String
    let preparedStatusEnabled: String
    let schedulePickupEnabled: String
    let deliveryEnabled: String
    let curbsidePickupEnabled: String
    let street: String
    let street2: String
    let city: String
    let postalCode: String
    let region: String
    let countryCode: CountryCode
    let phone: String?
    let email: String?
    let sellerType: SellerType
    var businessType: String?
    let giftCardBusinessType: String?
    var merchantLogoURL: URL?
    var merchantURL: URL?
    var id: String
    
    init(store: Datum) {
        self.siteId = store.siteID
        self.userId = store.ownerID
        self.pickupEnabled = store.pickupEnabled
        self.preparedStatusEnabled = store.preparedStatusEnabled
        self.schedulePickupEnabled = store.schedulePickupEnabled
        self.deliveryEnabled = store.deliveryEnabled
        self.curbsidePickupEnabled = store.curbsidePickupEnabled
        self.street = store.street
        self.street2 = store.street2
        self.city = store.city
        self.postalCode = store.postalCode
        self.region = store.region
        self.countryCode = store.countryCode
        self.phone = store.phone
        self.email = store.email
        self.displayName = store.displayName
        self.id = store.ownerID
        self.merchantLogoURL = nil
        self.giftCardBusinessType = nil
        self.sellerType = store.sellerType
        self.id = [store.displayName, store.ownerID, store.siteID].joined(separator: "-")
    }
}

class SellerMultiSearchFetcher: ObservableObject {
    private var cancellable: AnyCancellable?
    
    @Published var results: Result<[SellerSearchResultViewModel], Error>?
    var allModels: [SellerSearchResultViewModel] = []
    
    private var currentPage = 0 // on finish, bump page
    
    func filterResults(with category: SearchCategoryFilters) {        
        
        var filteredModels: [SellerSearchResultViewModel]
        switch category {
        case .all:
            self.results = .success(allModels)
            return
        case .food:
            filteredModels = allModels.filter({ model in
                model.businessType == "food_truck_cart" ||
                model.businessType == "grocery_market" ||
                model.businessType == "food_stores_convenience_stores_and_specialty_markets" ||
                model.businessType == "restaurant" ||
                model.businessType == "coffee_tea_shop" ||
                model.businessType == "bakery" ||
                model.sellerType == .foodAndDrink
            })
        case .retail:
            filteredModels = allModels.filter { $0.businessType == "clothing_and_accessories" || $0.sellerType == .retail }
        case .restaurants:
            filteredModels = allModels.filter { $0.businessType == "restaurant" }
        case .coffeeAndTea:
            filteredModels = allModels.filter { $0.businessType == "coffee_tea_shop" }
        case .barClubLounge:
            filteredModels = allModels.filter { $0.businessType == "bar_club_lounge" }
        case .bakery:
            filteredModels = allModels.filter { $0.businessType == "bakery" }
        case .beautyAndBarber:
            filteredModels = allModels.filter { $0.businessType == "beauty_and_barber_shops" }
        case .medical:
            filteredModels = allModels.filter { $0.businessType == "medical_services_and_health_practitioners" }
        case .artsAndCrafts:
            filteredModels = allModels.filter { $0.businessType == "artists_supply_and_craft_shops" }
        }
        
        self.results = .success(filteredModels)
    }
    
    func search(coordinate : CLLocationCoordinate2D) {
        // make seller-map url
        var sellerMapComponents = URLComponents()
            sellerMapComponents.scheme = "https"
            sellerMapComponents.host = "weebly.com"
            sellerMapComponents.path = "/app/store/api/v1/seller-map/lat/\(coordinate.latitude)/lng/\(coordinate.longitude)"
            sellerMapComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(currentPage)"),
                URLQueryItem(name: "per_page", value: "\(120)")
            ]
        
        guard let sellerMapURL = sellerMapComponents.url else {
            assertionFailure("no url")
            return
        }
        
        let sellerMapPublisher = URLSession.shared.dataTaskPublisher(for: sellerMapURL)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: SellerFromCoordsResult.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
        
        // make giftcard api request
        //https://giveandgetlocal.com/services/squareup.giftcard.api.ExternalGiftCardDiscoveryService/SearchEGiftUnitProfiles
        
        guard let url = URL(string: "https://giveandgetlocal.com/services/squareup.giftcard.api.ExternalGiftCardDiscoveryService/SearchEGiftUnitProfiles") else { return }
        var giftCardsRequest = URLRequest(url: url)
        giftCardsRequest.httpMethod = "POST"
        giftCardsRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let payload = SquareGiftCardsPayload(coordinates: Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude))
            let body = try JSONEncoder().encode(payload)
            giftCardsRequest.httpBody = body
        } catch {
            assertionFailure(String(describing: error))
        }
        
        let giftCardsPublisher = URLSession.shared.dataTaskPublisher(for: giftCardsRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: SquareSellerSearchResult.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
        
        cancellable = Publishers.Zip(
            sellerMapPublisher,
            giftCardsPublisher
        ).sink(receiveCompletion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.results = .failure(error)
            case .finished:
                strongSelf.currentPage = strongSelf.currentPage + 1
            }
        }, receiveValue: { [weak self] mapResult, giftCardResult in
            // we build using just the seller-map api results b/c we use the user id / site id for store url searching
            let mapResults = mapResult.data.map { SellerSearchResultViewModel(store: $0) }
            
            var profilesByName = [String: UnitProfile]()
            for profile in giftCardResult.unitProfiles {
                profilesByName[profile.businessName] = profile
            }
            
            let updatedResults = mapResults.map { mapResult -> SellerSearchResultViewModel in
                var tempResult = mapResult
                if let matchingProfile = profilesByName[tempResult.displayName] {
                    if let merchantLogoURL = matchingProfile.merchantLogoURL, let logoURL = URL(string: merchantLogoURL)  {
                        tempResult.merchantLogoURL = logoURL
                    }
                    tempResult.businessType = matchingProfile.businessType
                }
                
                return tempResult
            }
            self?.allModels = updatedResults
            self?.results = .success(updatedResults)
        })
    }
}

class FetchTask<T: Decodable>: ObservableObject {
    
    private var cancellable: AnyCancellable?
    @Published var finished = false
    @Published var result: Result<T, Error>?
    
    func fetchModel(withURL url: URL) {
        guard !finished else { return }
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                throw HTTPError.statusCode
            }
            return output.data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            self?.finished = true
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.result = .failure(error)
            }
        }, receiveValue: { [weak self] model in
            self?.result = .success(model)
        })
    }
}

class PostTask<T: Decodable>: ObservableObject {
    private var cancellable: AnyCancellable?
    @Published var finished = false
    @Published var result: Result<T, Error>?
    
    func fetchModel(request: URLRequest) {
        guard !finished else { return }
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.finished = true
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.result = .failure(error)
                }
            }, receiveValue: { [weak self] model in
                self?.result = .success(model)
            })
    }
}
