//
//  StoresFromCoordsTask.swift
//  KVMarketSquare
//
//  Created by Kevin Taniguchi on 12/13/21.
//

import Foundation

//curl 'https://www.weebly.com/app/store/api/v1/seller-map/lat/44.9045212/lng/-93.173926?page=0&per_page=100' \
//  -H 'Connection: keep-alive' \
//  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
//  -H 'Accept: application/json, text/plain, */*' \
//  -H 'sec-ch-ua-mobile: ?0' \
//  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36' \
//  -H 'sec-ch-ua-platform: "macOS"' \
//  -H 'Origin: https://map.giveandgetlocal.com' \
//  -H 'Sec-Fetch-Site: cross-site' \
//  -H 'Sec-Fetch-Mode: cors' \
//  -H 'Sec-Fetch-Dest: empty' \
//  -H 'Referer: https://map.giveandgetlocal.com/' \
//  -H 'Accept-Language: en-US,en;q=0.9' \
//  --compressed

final class StoresFromCoordsController {
    private let urlComponents: URLComponents

//    'https://www.weebly.com/app/store/api/v1/seller-map/lat/44.9045212/lng/-93.173926?page=0&per_page=100'
    
    init() {
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "weebly.com"
            components.path = "/app/store/api/v1/seller-map"
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(0)"), // not gonna care about this now
                URLQueryItem(name: "per_page", value: "\(100)")
            ]
        
        self.urlComponents = components
    }
    
    private func coordinatePath(lat: Double, lon: Double) -> String {
        "/lat/\(lat)/lng/\(lon)"
    }
}
