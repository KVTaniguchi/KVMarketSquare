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
