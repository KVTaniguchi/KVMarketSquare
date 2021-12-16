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
    @StateObject var task: FetchTask<SellerFromCoordsResult> = FetchTask<SellerFromCoordsResult>()
    @EnvironmentObject private var appData: AppData
    @State private var selectedStore: SellerAppData?
    
    @StateObject var multiSearch: SellerMultiSearchFetcher = SellerMultiSearchFetcher()
    
    private let url: URL
    private let coordinate: CLLocationCoordinate2D
    
    init?(coordinate : CLLocationCoordinate2D) {
        // todo implement paging
        //    'https://www.weebly.com/app/store/api/v1/seller-map/lat/{lat}/lng/{lng}?page=0&per_page=100'
        var sellerMapComponents = URLComponents()
            sellerMapComponents.scheme = "https"
            sellerMapComponents.host = "weebly.com"
            sellerMapComponents.path = "/app/store/api/v1/seller-map/lat/\(coordinate.latitude)/lng/\(coordinate.longitude)"
            sellerMapComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(0)"), // not gonna care about this now
                URLQueryItem(name: "per_page", value: "\(120)")
            ]
        
        guard let url = sellerMapComponents.url else {
            assertionFailure("no url")
            return nil
        }
        
        self.url = url
        self.coordinate = coordinate
    }
    
    var body: some View {
        Group {
            switch multiSearch.results {
            case .success(let models):
                List(models) { model in
                    Button {
                        selectedStore = SellerAppData(store: model)
                    } label: {
                        FavoriteTileView(store: SellerAppData(store: model))
                        // todo implement paging by inserting a view somewhere in list whose appearance triggers another page
                        // track how many pages we have done
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
