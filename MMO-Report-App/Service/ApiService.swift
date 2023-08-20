import UIKit

enum ApiError: Error {
    case invalidURL
    case requestError(description: String)
    case invalidResponse
    case invalidData
    case decodingError(description: String)
}

enum TypeOfInformation {
    case game(params: [String: String]?)
    case news
    
    var baseURL: String {
        "https://www.mmobomb.com/api1"
    }

    var url: URL? {
        switch self {
        case .game(let params):
            guard let params = params else {
                return getUrl(of: "\(baseURL)/games?")
            }
            var urlWithParams = URLComponents(string: "\(baseURL)/games?")
            let configuredParams = setupQueryParams(using: params)
            urlWithParams?.queryItems = configuredParams
             let url = urlWithParams?.url
            return url
        case .news:
            return getUrl(of: "\(baseURL)/latestnews")
        }
    }

    func setupQueryParams(using params: [String: String]) -> [URLQueryItem] {
        let queryParams: [URLQueryItem] = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return queryParams
    }

    func getUrl(of value: String) -> URL? {
        URL(string: value)
    }
}

protocol ApiServiceProtocol {
    func fetchNews(completion: @escaping (Result<[MMOGeneralNewsResponse], ApiError>) -> Void)
    func fetchMMOs(keywords: String?, completion: @escaping (Result<[MMOInformationResponse], ApiError>) -> Void)
    func fetchImage(url: String, completion: @escaping (Data) -> Void)
}

struct APIService: ApiServiceProtocol {
    
    func fetchNews(completion: @escaping (Result<[MMOGeneralNewsResponse], ApiError>) -> Void) {
        fetchData(url: TypeOfInformation.news.url, completion: completion)
    }
    
    func fetchMMOs(keywords: String? = nil, completion: @escaping (Result<[MMOInformationResponse], ApiError>) -> Void) {
        fetchData(url: TypeOfInformation.game(params: nil).value, completion: completion)
    }
    
    func fetchImage(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }

            guard let data = data else { return }
            completion(data)
        }
        dataTask.resume()
    }

    private func fetchData<T: Codable>(url: URL?, completion: @escaping (Result<T, ApiError>) -> Void) {
        guard let url = url else {
            return completion(.failure(ApiError.invalidURL))
        }
        print("URLLLLLLLLL: \(url)")
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestError(description: error.localizedDescription)))
                return
            }

            guard let data = data else {
                return completion(.failure(.invalidData))
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError(description: error.localizedDescription)))
            }
        }
        dataTask.resume()
    }
}
