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
    
    let storeSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Address", text: $mapSearch.searchTerm)
                        .modifier(ClearButton(text: $mapSearch.searchTerm, results: $mapSearch.locationResults))
                }
                Section {
                    ForEach(mapSearch.locationResults, id: \.self) { location in
                        NavigationLink(destination:
                                        SellerSearchResultsView(locationResult: location)) {
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
            .navigationTitle("Market Square")
            .toolbar {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
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
    @StateObject private var viewModel = AddressToCoordinateResolver()

    init(locationResult : MKLocalSearchCompletion) {
        self.locationResult = locationResult
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                Text("Loading...")
            } else {
                SellerResultsListView(coordinate: viewModel.coordinate)
            }
        }
        .onAppear {
            viewModel.reconcileLocation(location: locationResult)
        }
        .onDisappear {
            viewModel.clear()
        }
        .navigationTitle(Text(locationResult.title))
    }
}

struct SellerResultsListView: View {
    @StateObject var task: FetchTask<SellerFromCoordsResult> = FetchTask<SellerFromCoordsResult>()
    
    private let url: URL
    
//    'https://www.weebly.com/app/store/api/v1/seller-map/lat/44.9045212/lng/-93.173926?page=0&per_page=100'
    
    init?(coordinate : CLLocationCoordinate2D) {
        var sellerMapComponents = URLComponents()
            sellerMapComponents.scheme = "https"
            sellerMapComponents.host = "weebly.com"
            sellerMapComponents.path = "/app/store/api/v1/seller-map/lat/\(coordinate.latitude)/lng/\(coordinate.longitude)"
            sellerMapComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(0)"), // not gonna care about this now
                URLQueryItem(name: "per_page", value: "\(100)")
            ]
        
        guard let url = sellerMapComponents.url else {
            assertionFailure("no url")
            return nil
        }
        
        self.url = url
    }
    
    var body: some View {
        switch task.result {
        case .success(let model):
            List(model.data) { store in
                Text(store.displayName)
            }
        case .failure(let error):
            Text(String(describing: error))
        case .none:
            ProgressView().onAppear(perform: {
                withAnimation {
                    self.task.fetchModel(withURL: self.url)
                }
            })
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
