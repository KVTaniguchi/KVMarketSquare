import Foundation
import Combine

enum HTTPError: LocalizedError {
    case statusCode
}

class FetchTask<T: Decodable>: ObservableObject {
    
    private var cancellable: AnyCancellable?
    @Published var finished = false
    @Published var result: Result<T, Error>?
    
    func fetchModel(withURL url: URL) {
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
                self?.result = .failure(error)
            }
        }, receiveValue: { [weak self] model in
            self?.result = .success(model)
        })
    }
}

class PostTask<T: Decodable>: ObservableObject {
    private var cancellable: AnyCancellable?
    @Published var finished = false
    @Published var result: Result<T, Error>?
    
    func fetchModel(request: URLRequest) {
        guard !finished else { return }
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
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
                    print("#### sink error")
                    self?.result = .failure(error)
                }
            }, receiveValue: { [weak self] model in
                self?.result = .success(model)
            })
    }
}
