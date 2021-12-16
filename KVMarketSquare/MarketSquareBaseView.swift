import SwiftUI

struct StoreWebView: View {
    let store: SellerAppData
    @StateObject var task = PostTask<URLStoresResponse>()
    @Environment(\.dismiss) var dismiss
    @State private var actualURL: URL?
    private let request: URLRequest
    
    
    // start fetching on init
    init?(store: SellerAppData) {
        self.store = store
        
        guard let url = URL(string: "https://www.weebly.com/app/website/api/v1/sites/urls") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let payload = URLLookupPayload(userSites: [SellerIdentifier(userID: store.userId, siteID: store.siteId)])
            let body = try JSONEncoder().encode(payload)
            request.httpBody = body
        } catch {
            assertionFailure(String(describing: error))
            return nil
        }
        
        self.request = request
        self.actualURL = nil
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch task.result {
                case .success(let response):
                    if let url = responseWebsite(from: response) {
                        WebView(url: url)
                    } else {
                        Text("Sorry, this seller does not have a Square website")
                    }
                case .failure(let error):
                    Text(String(describing: error))
                case .none:
                    ProgressView().onAppear(perform: {
                        withAnimation {
                            self.task.fetchModel(request: self.request)
                        }
                    })
                }
            }
            .navigationBarTitle(store.displayName ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavBackButton(type: .close, dismissAction: dismiss)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Todo: add better logic here to open website in browser
                    if let actualUrl = actualURL {
                        Link(destination: actualUrl) {
                            Text(Localization.key(.OpenInBrowser))
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
    
    private func responseWebsite(from response: URLStoresResponse) -> URL? {
        if let link = response[self.store.userId]?[self.store.siteId]?.url, let url = URL(string: link)   {
            return url
        }
        return nil
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
    let url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
