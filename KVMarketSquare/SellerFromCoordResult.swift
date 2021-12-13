////////
///
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sellerFromCoordResult = try? newJSONDecoder().decode(SquareMapSellerSearchResult.self, from: jsonData)

import Foundation

// MARK: - SellerFromCoordsResult
struct SellerFromCoordsResult: Codable {
    let data: [Datum]
    let meta: Meta
}

// MARK: - Datum
struct Datum: Codable {
    let id, ownerID, siteID: String
    let addressID: Int?
    let nickname: String?
    let displayName, businessName, siteTitle: String
    let sellerType: SellerType
    let pickupEnabled, preparedStatusEnabled: String
    let pickupTimezone: PickupTimezone
    let orderPrepTime: Int?
    let schedulePickupEnabled, pickupHours: String
    let lastOrderDate: Date
    let isSquareLocation: Int
    let pickupInstructions: String?
    let squareBusinessHours, deliveryEnabled: String
    let deliveryFee, deliveryOrderSubtotalMinimum: String?
    let deliveryEstimatedMinDurationMinutes, deliveryEstimatedMaxDurationMinutes: Int?
    let curbsidePickupEnabled, street, street2, postalCode: String
    let city: String
    let region: Region
    let countryCode: CountryCode
    let phone, email: String?
    let storeLatLon: String
    let createdAt, updatedAt: Date?
    let partnerSeller: String
    let url: String?
    let timestamp: String
    let geodist: Double
    let pickupTimezoneInfo: PickupTimezoneInfo

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case siteID = "site_id"
        case addressID = "address_id"
        case nickname
        case displayName = "display_name"
        case businessName = "business_name"
        case siteTitle = "site_title"
        case sellerType = "seller_type"
        case pickupEnabled = "pickup_enabled"
        case preparedStatusEnabled = "prepared_status_enabled"
        case pickupTimezone = "pickup_timezone"
        case orderPrepTime = "order_prep_time"
        case schedulePickupEnabled = "schedule_pickup_enabled"
        case pickupHours = "pickup_hours"
        case lastOrderDate = "last_order_date"
        case isSquareLocation = "is_square_location"
        case pickupInstructions = "pickup_instructions"
        case squareBusinessHours = "square_business_hours"
        case deliveryEnabled = "delivery_enabled"
        case deliveryFee = "delivery_fee"
        case deliveryOrderSubtotalMinimum = "delivery_order_subtotal_minimum"
        case deliveryEstimatedMinDurationMinutes = "delivery_estimated_min_duration_minutes"
        case deliveryEstimatedMaxDurationMinutes = "delivery_estimated_max_duration_minutes"
        case curbsidePickupEnabled = "curbside_pickup_enabled"
        case street, street2
        case postalCode = "postal_code"
        case city, region
        case countryCode = "country_code"
        case phone, email
        case storeLatLon = "store_lat_lon"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case partnerSeller = "partner_seller"
        case url, timestamp
        case geodist = "geodist()"
        case pickupTimezoneInfo = "pickup_timezone_info"
    }
}

enum PickupTimezone: String, Codable {
    case americaChicago = "America/Chicago"
    case americaLosAngeles = "America/Los_Angeles"
    case americaNorthDakotaCenter = "America/North_Dakota/Center"
}

// MARK: - PickupTimezoneInfo
struct PickupTimezoneInfo: Codable {
    let name: PickupTimezone
    let currentTime24_Format: CurrentTime24_Format
    let utcOffsetString: UTCOffsetString
    let utcOffsetMinutes: Int

    enum CodingKeys: String, CodingKey {
        case name
        case currentTime24_Format = "current_time_24_format"
        case utcOffsetString = "utc_offset_string"
        case utcOffsetMinutes = "utc_offset_minutes"
    }
}

enum CurrentTime24_Format: String, Codable {
    case the0812 = "08:12"
    case the1012 = "10:12"
}

enum UTCOffsetString: String, Codable {
    case the0600 = "-06:00"
    case the0800 = "-08:00"
}

enum Region: String, Codable {
    case mn = "MN"
}

enum SellerType: String, Codable {
    case foodAndDrink = "food_and_drink"
    case retail = "retail"
}

// MARK: - Meta
struct Meta: Codable {
    let total, count, perPage, currentPage: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

