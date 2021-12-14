import SwiftUI

struct StoreWebView: View {
    let store: SellerAppData
    let task = PostTask<URLStoresResponse>()
    
    // start fetching on init
    init?(store: SellerAppData) {
        self.store = store
        
        guard let url = URL(string: "https://www.weebly.com/app/website/api/v1/sites/urls") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let payload = URLLookupPayload(userSites: [SellerIdentifier(userID: store.userId, siteID: store.siteId)])
            
            print(payload)
            let body = try JSONEncoder().encode(payload)
            request.httpBody = body
        } catch {
            assertionFailure(String(describing: error))
            return nil
        }
        
        task.fetchModel(request: request)
    }
    
    var body: some View {
        switch task.result {
        case .success(let response):
            // this needs a ton of cleanup but it works
            WebView(url: URL(string: response[store.userId]!.values.first!.url)!)
        case .failure(let error):
            Text(String(describing: error))
        case .none:
            Text("no response")
        }
    }
}

struct URLLookupPayload: Codable {
    let userSites: [SellerIdentifier]

    enum CodingKeys: String, CodingKey {
        case userSites = "user_sites"
    }
}

struct SellerIdentifier: Codable {
    let userID, siteID: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case siteID = "site_id"
    }
}

// MARK: - URLStoresResponseValue
struct URLStoresResponseValue: Codable {
    let url: String
}

typealias URLStoresResponse = [String: [String: URLStoresResponseValue]]

import WebKit
 
struct WebView: UIViewRepresentable {
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
