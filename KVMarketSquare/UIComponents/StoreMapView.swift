//
//  StoreMapView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-16.
//

import SwiftUI
import MapKit

struct StoreLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct StoreMapView: View {
    var store: SellerAppData
    @State private var region = MKCoordinateRegion()
    @State private var storeLocation: [StoreLocation] = []
    
    init(store: SellerAppData) {
        self.store = store
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: storeLocation) {
            MapMarker(coordinate: $0.coordinate)
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 300)
        .cornerRadius(10)
        .onAppear {
            let coordinates = store.storeLatLon.components(separatedBy: ",")
            let lat = Double(coordinates[0]) ?? 0
            let lon = Double(coordinates[1]) ?? 0
            
            self.storeLocation = [StoreLocation(
                name: store.displayName ?? "",
                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)
            )]
            
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
}

struct StoreMapView_Previews: PreviewProvider {
    static var previews: some View {
        StoreMapView(store: SellerAppData.preview)
    }
}
