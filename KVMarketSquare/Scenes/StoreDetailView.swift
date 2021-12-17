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
            VStack(alignment: .leading) {
                Text(store.displayName ?? "").font(.largeTitle)
                ScrollView {
                    VStack(spacing: 32) {
                        basicInfoSection
                        
                        StoreServiceSection(store: store)
                            .padding(16)
                            .background(Color.key(.background))
                            .cornerRadius(10)
                        
                        // Add Map Info Here
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal, 16)
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
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.addressString)
            
            if let phone = store.phone, !phone.isEmpty {
                IconHeaderText(type: .phone, text: phone)
            }
            
            if let email = store.email {
                IconHeaderText(type: .email, text: email)
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
