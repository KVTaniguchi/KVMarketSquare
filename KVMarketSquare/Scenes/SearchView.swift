//
//  ContentView.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/3/21.
//

import CoreLocation
import MapKit
import SwiftUI

struct SearchView: View {
    @StateObject private var mapSearch = MapSearch()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var appData: AppData
    
    let storeSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            HolidayWrapperView {
                Form {
                    Section {
                        TextField(Localization.key(.SearchFieldTitle), text: $mapSearch.searchTerm)
                            .modifier(ClearButton(text: $mapSearch.searchTerm, results: $mapSearch.locationResults))
                            .disableAutocorrection(true)
                    }
                    Section {
                        ForEach(mapSearch.locationResults, id: \.self) { location in
                            NavigationLink(destination:
                                            SellerSearchResultsView(locationResult: location).environmentObject(appData)) {
                                                VStack(alignment: .leading) {
                                                    Text(location.title)
                                                    Text(location.subtitle)
                                                        .font(.system(.caption)
                                                    )
                                                }
                            }
                        }
                    }
                }
                .navigationTitle(Localization.key(.SearchViewTitle))
                .toolbar {
                    NavBackButton(type: .close, dismissAction: dismiss)
                }
            }
        }
    }
}

struct SellerSearchResultsView: View {
    var locationResult : MKLocalSearchCompletion
    @StateObject private var viewModel = AddressToCoordinateResolver()
    @EnvironmentObject private var appData: AppData
    @Environment(\.dismiss) var dismiss

    init(locationResult : MKLocalSearchCompletion) {
        self.locationResult = locationResult
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                Text("Loading...")
            } else {
                HolidayWrapperView {
                    SellerResultsListView(coordinate: viewModel.coordinate)?.environmentObject(appData)
                }
            }
        }
        .onAppear {
            viewModel.reconcileLocation(location: locationResult)
        }
        .onDisappear {
            viewModel.clear()
        }
        .navigationTitle(Text(locationResult.title))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavBackButton()
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                    }, label: {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .tint(.blue)
                    }
                )
            }
        }
    }
}

enum SearchCategoryFilters: String, CaseIterable {
    case all = "All Sellers"
    case food = "Food & Drink"
    case retail = "Retail"
    case restaurants = "Restaurants"
    case coffeeAndTea = "Coffee & Tea"
    case bakery = "Bakery"
    case barClubLounge = "Bar or Club"
    case beautyAndBarber = "Beauty or Barber"
    case medical = "Medical"
    case artsAndCrafts = "Arts & Crafts"
    
    func button(fetcher: SellerMultiSearchFetcher, selectedFilter: Binding<SearchCategoryFilters>) -> some View {
        let isSelected = self == selectedFilter.wrappedValue
        
        return Button {
            selectedFilter.wrappedValue = self
            fetcher.filterResults(with: self)
        } label: {
            Text(self.rawValue).padding(4).border(isSelected ? .primary : .secondary, width: isSelected ? 4 : 1)
        }
        .contentShape(Rectangle())
    }
    
    static func availableCases(for results: [SellerSearchResultViewModel]) -> [SearchCategoryFilters] {
        var filters: [SearchCategoryFilters] = [.all]
        
        if results.contains(where: {
            $0.sellerType == .foodAndDrink ||
            $0.businessType == "food_truck_cart" ||
            $0.businessType == "grocery_market" ||
            $0.businessType == "food_stores_convenience_stores_and_specialty_markets" ||
            $0.businessType == "restaurant" ||
            $0.businessType == "coffee_tea_shop" ||
            $0.businessType == "bakery"
        }) {
            filters.append(.food)
        }
        
        if results.contains(where: { $0.sellerType == .retail || $0.businessType == "clothing_and_accessories" }) {
            filters.append(.retail)
        }
        
        if results.contains(where: {
            $0.businessType == "restaurant"
        }) {
            filters.append(.restaurants)
        }
        
        if results.contains(where: {
            $0.businessType == "coffee_tea_shop"
        }) {
            filters.append(.coffeeAndTea)
        }
        
        if results.contains(where: {
            $0.businessType == "bar_club_lounge"
        }) {
            filters.append(.barClubLounge)
        }

        if results.contains(where: {
            $0.businessType == "bakery"
        }) {
            filters.append(.bakery)
        }
        
        if results.contains(where: {
            $0.businessType == "beauty_and_barber_shops"
        }) {
            filters.append(.beautyAndBarber)
        }
        
        if results.contains(where: {
            $0.businessType == "medical_services_and_health_practitioners"
        }) {
            filters.append(.medical)
        }
        
        if results.contains(where: {
            $0.businessType == "artists_supply_and_craft_shops"
        }) {
            filters.append(.artsAndCrafts)
        }
        
        return filters
    }
}

struct SellerResultsListView: View {
    @EnvironmentObject private var appData: AppData
    @State private var selectedStore: SellerAppData?
    @State private var selectedFilter: SearchCategoryFilters = .all
    
    @StateObject var multiSearch: SellerMultiSearchFetcher = SellerMultiSearchFetcher()
    
    private let coordinate: CLLocationCoordinate2D
    
    init?(coordinate : CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    var body: some View {
        Group {
            switch multiSearch.results {
            case .success(let models):
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(SearchCategoryFilters.availableCases(for: multiSearch.allModels), id: \.self) { filterType in
                                filterType.button(fetcher: multiSearch, selectedFilter: $selectedFilter)
                            }
                        }
                    }
                    
                    List(models) { model in
                        Button {
                            selectedStore = SellerAppData(store: model)
                        } label: {
                            FavoriteTileView(store: SellerAppData(store: model))
                        }
                    }
                }
            case .failure(let error):
                Text(String(describing: error))
            case .none:
                ProgressView().onAppear(perform: {
                    withAnimation {
                        self.multiSearch.search(coordinate: self.coordinate)
                    }
                })
            }
        }
        .fullScreenCover(item: $selectedStore) { store in
            StoreWebView(store: store)
        }
    }
}
