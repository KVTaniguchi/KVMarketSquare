import Foundation
import Combine

enum HTTPError: LocalizedError {
    case statusCode
}

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


//curl 'https://giveandgetlocal.com/services/squareup.giftcard.api.ExternalGiftCardDiscoveryService/SearchEGiftUnitProfiles' \
//  -H 'authority: giveandgetlocal.com' \
//  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"' \
//  -H 'x-csrf-token: null' \
//  -H 'sec-ch-ua-mobile: ?0' \
//  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36' \
//  -H 'content-type: application/json; charset=UTF-8' \
//  -H 'accept: application/json, text/javascript, */*' \
//  -H 'x-requested-with: XMLHttpRequest' \
//  -H 'sec-ch-ua-platform: "macOS"' \
//  -H 'origin: https://giveandgetlocal.com' \
//  -H 'sec-fetch-site: same-origin' \
//  -H 'sec-fetch-mode: cors' \
//  -H 'sec-fetch-dest: empty' \
//  -H 'referer: https://giveandgetlocal.com/?address=1384%20Laurel%20Avenue%2C%20Saint%20Paul%2C%20MN%2C%20USA' \
//  -H 'accept-language: en-US,en;q=0.9' \
//  --data-raw '{"coordinates":{"latitude":44.9448003,"longitude":-93.1588089},"business_categories":["FOOD_AND_DRINK","HEALTH_CARE_AND_FITNESS"],"scale":"LARGE"}' \
//  --compressed
class FetchTask<T: Decodable>: ObservableObject {
    
    private var cancellable: AnyCancellable?
    let url: URL
    
    @Published var model: T?
    @Published var error: Error?
    @Published var finished = false
    
    init(url: URL) {
        self.url = url
    }
    
    func fetchModel() {
        guard !finished else { return }
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                throw HTTPError.statusCode
            }
            return output.data
        }
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            self?.finished = true
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.error = error
            }
        }, receiveValue: { [weak self] model in
            self?.model = model
        })
    }
}
