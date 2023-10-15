import Foundation

protocol ImageDownloaderServiceProtocol {
    func fetchImage(url: String, completion: @escaping (Data) -> Void)
}

struct ImageDownloaderService: ImageDownloaderServiceProtocol {
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInitiated)

    func fetchImage(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }

            guard let data = data else { return }
            completion(data)
        }
        dataTask.resume()
    }

    func fetchImage(listOfUrls: [String], completion: @escaping (Data) -> Void) {

        guard let url = URL(string: listOfUrls[0]) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }

            guard let data = data else { return }
            completion(data)
        }
        dataTask.resume()
    }
}
