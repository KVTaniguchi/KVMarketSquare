//
//  SearchCategoryFilters.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/16/21.
//

import Foundation
import SwiftUI

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
        let isSelected = selectedFilter.wrappedValue == self
        
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
