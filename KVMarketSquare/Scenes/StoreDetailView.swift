//
//  StoreDetailView.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-16.
//

import SwiftUI

struct StoreDetailView: View {
    @EnvironmentObject private var appData: AppData
    @State private var showWebView: Bool = false
    var store: SellerAppData
    
    var body: some View {
        HolidayWrapperView {
            ScrollView {
                VStack(spacing: 16) {
                    titleSection
                    
                    basicInfoSection
                    
                    StoreServiceSection(store: store)
                        .padding(16)
                        .background(Color.key(.background))
                        .cornerRadius(10)
                    
                    StoreMapView(store: store)
                }
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavBackButton()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    FavoriteButton(sellerStore: store)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showWebView.toggle()
                    } label: {
                        Image(systemName: "globe")
                            .renderingMode(.template)
                            .tint(.blue)
                    }

                }
            }
            .fullScreenCover(isPresented: $showWebView) {
                StoreWebView(store: store)
            }
        }
    }
    
    private var titleSection: some View {
        HStack(spacing: 4) {
            if let logoImage = KVAsyncImage(url: store.merchantLogoURL) {
                logoImage
                    .frame(width: 72, height: 72)
            }
            
            Text(store.displayName ?? "")
                .font(.largeTitle)
                .bold()
            
            Spacer()
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            IconHeaderText(type: .address, text: store.addressString)
            
            HStack {
                if let phone = store.phone, !phone.isEmpty {
                    IconHeaderText(type: .phone, text: phone)
                }
                
                if let email = store.email, !email.isEmpty {
                    IconHeaderText(type: .email, text: email)
                }
            }
        }
        .horizontalAlignment(.leading)
    }
}

struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreDetailView(store: SellerAppData.preview)
    }
}
