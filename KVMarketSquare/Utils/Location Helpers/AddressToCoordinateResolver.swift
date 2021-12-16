//
//  AddressToCoordinateResolver.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/16/21.
//

import Foundation
import MapKit
import CoreLocation

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
