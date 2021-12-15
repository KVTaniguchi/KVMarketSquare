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
    @Binding var showingSearchSheet: Bool
    @StateObject private var mapSearch = MapSearch()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var appData: AppData
    
    let storeSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(Localization.key(.SearchFieldTitle), text: $mapSearch.searchTerm)
                        .modifier(ClearButton(text: $mapSearch.searchTerm, results: $mapSearch.locationResults))
                        .disableAutocorrection(true)
                }
                Section {
                    ForEach(mapSearch.locationResults, id: \.self) { location in
                        NavigationLink(destination:
                                        SellerSearchResultsView(locationResult: location, showingSearchSheet: $showingSearchSheet).environmentObject(appData)) {
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

class AddressToCoordinateResolver : ObservableObject {
    @Published var isLoading = true
    @Published var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    var coordinateForMap : CLLocationCoordinate2D {
        coordinate
    }
    
    func reconcileLocation(location: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error == nil, let coordinate = response?.mapItems.first?.placemark.coordinate {
                self.coordinate = coordinate
                self.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                self.isLoading = false
            }
        }
    }
    
    func clear() {
        isLoading = true
    }
}

struct SellerSearchResultsView: View {
    var locationResult : MKLocalSearchCompletion
    @Binding var showingSearchSheet: Bool
    @StateObject private var viewModel = AddressToCoordinateResolver()
    @EnvironmentObject private var appData: AppData

    init(locationResult : MKLocalSearchCompletion, showingSearchSheet: Binding<Bool>) {
        self.locationResult = locationResult
        self._showingSearchSheet = showingSearchSheet
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                Text("Loading...")
            } else {
                SellerResultsListView(coordinate: viewModel.coordinate)?.environmentObject(appData)
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
                Button("Save",
                    action: {
                        showingSearchSheet.toggle()
                    }
                ).tint(.blue)
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
                        selectedStore = SellerAppData(
                            siteId: model.siteId,
                            userId: model.userId,
                            city: model.city,
                            displayName: model.displayName,
                            merchantLogoURL: model.merchantLogoURL,
                            giftCardBusinessType: model.businessType,
                            sellerType: model.sellerType
                        )
                    } label: {
                        FavoriteTileView(store: SellerAppData(
                            siteId: model.siteId,
                            userId: model.userId,
                            city: model.city,
                            displayName: model.displayName,
                            merchantLogoURL: model.merchantLogoURL,
                            giftCardBusinessType: model.businessType,
                            sellerType: model.sellerType
                        ))
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

// shows a map :shrug maybe use it?
struct Detail : View {
    var locationResult : MKLocalSearchCompletion
    @StateObject private var viewModel = AddressToCoordinateResolver()
    
    struct Marker: Identifiable {
        let id = UUID()
        var location: MapMarker
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                Text("Loading...")
            } else {
                // search for weebly stores
                
                // using mapsearch?
                
                Map(coordinateRegion: $viewModel.region,
                    annotationItems: [Marker(location: MapMarker(coordinate: viewModel.coordinateForMap))]) { (marker) in
                    marker.location
                }
            }
        }.onAppear {
            viewModel.reconcileLocation(location: locationResult)
        }.onDisappear {
            viewModel.clear()
        }
        .navigationTitle(Text(locationResult.title))
    }
}

public struct ClearButton: ViewModifier {
    @Binding var text: String
    @Binding var results: [MKLocalSearchCompletion]

    public init(text: Binding<String>, results: Binding<[MKLocalSearchCompletion]>) {
        self._text = text
        self._results = results
    }

    public func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            // onTapGesture is better than a Button here when adding to a form
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.secondary)
                .opacity(text == "" ? 0 : 1)
                .onTapGesture {
                    self.text = ""
                    self.results = []
                }
        }
    }
}



//

// what local api is this hitting?
// giveandgetlocal.com
// https://giveandgetlocal.com/?address=1384%20Laurel%20Avenue%2C%20Saint%20Paul%2C%20MN%2C%20USA
// https://giveandgetlocal.com/?address=1384 Laurel Avenue, Saint Paul, MN, USA

// search field

// location

// geocode?

//
