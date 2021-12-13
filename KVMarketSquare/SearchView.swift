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
                                        Detail(locationResult: location)) {
                                            VStack(alignment: .leading) {
                                            Text(location.title)
                                Text(location.subtitle)
                                    .font(.system(.caption))
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Market Square"))
            .toolbar {
                Button("Dismiss") {
                    dismiss()
                }
            }
        }
    }
}

class DetailViewModel : ObservableObject {
    @Published var isLoading = true
    @Published private var coordinate : CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    var coordinateForMap : CLLocationCoordinate2D {
        coordinate ?? CLLocationCoordinate2D()
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

// repurpose to show weebly search results
struct Detail : View {
    var locationResult : MKLocalSearchCompletion
    @StateObject private var viewModel = DetailViewModel()
    
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
            print("*******")
            print(locationResult)
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
