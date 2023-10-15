import Foundation

protocol MMOListServiceProtocol {
    func fetchListOfMMOsByListOfGenres(genres: [Genre], completion: @escaping ([MMOListByCategoryResponse]) -> Void, failure: @escaping (ApiError) -> Void)
}

struct MMOListService: MMOListServiceProtocol {
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "Global", qos: .utility)

    func fetchListOfMMOsByListOfGenres(genres: [Genre], completion: @escaping ([MMOListByCategoryResponse]) -> Void, failure: @escaping (ApiError) -> Void) {
        var listByCategory: [MMOListByCategoryResponse] = []

            genres.enumerated().forEach { index, category in
                group.enter()

            let url: URL? = TypeOfInformation.game(params: ["category": category.rawValue]).url

            guard let url = url else {
                defer { group.leave() }
                return failure(ApiError.invalidURL)
            }

            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

                defer { group.leave() }

                if let responseError = error {
                    failure(ApiError.requestError(description: responseError.localizedDescription))
                    return
                }

                guard let data = data else {
                    return failure(.invalidData)
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let result = try decoder.decode([MMOInformationResponse].self, from: data)
                    listByCategory.append(.init(genre: category,
                                                listOfMMOs: result))
                } catch {
                    failure(.decodingError(description: error.localizedDescription))
                }
            }
            dataTask.resume()
        }

        group.notify(queue: queue) {
                print("2222222222222")
            completion(listByCategory)
        }

    }
}
