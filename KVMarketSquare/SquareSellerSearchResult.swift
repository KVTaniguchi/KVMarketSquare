//
//  SquareSellerSearchResult.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/4/21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let squareSellerSearchResult = try? newJSONDecoder().decode(SquareSellerSearchResult.self, from: jsonData)

import Foundation

// dig through the names and try to match them up

//https://giveandgetlocal.com/services/squareup.giftcard.api.ExternalGiftCardDiscoveryService/SearchEGiftUnitProfiles

// payload
    //{{
    //  "coordinates": {
    //    "latitude": 44.9448003,
    //    "longitude": -93.1588089
    //  },
    //  "scale": "LARGE"
    //}}

// MARK: - SquareGiftCardsPayload
struct SquareGiftCardsPayload: Encodable {
    let coordinates: Coordinates
    let scale: String = "LARGE"
}

// MARK: - SquareSellerSearchResult
struct SquareSellerSearchResult: Codable {
    let status: String
    let unitProfiles: [UnitProfile]

    enum CodingKeys: String, CodingKey {
        case status
        case unitProfiles = "unit_profiles"
    }
}

// MARK: - UnitProfile
struct UnitProfile: Codable {
    let merchantToken, unitToken, businessName, mcc: String
    let merchantLogoURL: String?
    let cardColor: String?
    let globalAddress: GlobalAddress
    let coordinates: Coordinates
    let businessType: String
    let egiftOrderURL: String
    let customEgiftThemeURL: String?

    enum CodingKeys: String, CodingKey {
        case merchantToken = "merchant_token"
        case unitToken = "unit_token"
        case businessName = "business_name"
        case mcc
        case merchantLogoURL = "merchant_logo_url"
        case cardColor = "card_color"
        case globalAddress = "global_address"
        case coordinates
        case businessType = "business_type"
        case egiftOrderURL = "egift_order_url"
        case customEgiftThemeURL = "custom_egift_theme_url"
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double
}

// MARK: - GlobalAddress
struct GlobalAddress: Codable {
    let addressLine1, locality: String
    let administrativeDistrictLevel1: String
    let postalCode: String
    let countryCode: String
    let addressCoordinates: Coordinates?
    let addressLine2: String?

    enum CodingKeys: String, CodingKey {
        case addressLine1 = "address_line_1"
        case locality
        case administrativeDistrictLevel1 = "administrative_district_level_1"
        case postalCode = "postal_code"
        case countryCode = "country_code"
        case addressCoordinates = "address_coordinates"
        case addressLine2 = "address_line_2"
    }
}

