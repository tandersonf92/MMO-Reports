struct HomeViewModel {

    private let service: ApiServiceProtocol

    init(service: ApiServiceProtocol = APIService()) {
        self.service = service
    }

    func fetchMMOs(completion: @escaping ([MMOInformationResponse]) -> Void, error: @escaping (ApiError) -> Void) {
        service.fetchMMOs(keywords: nil) { result in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let failure):
                error(failure)
            }
        }
    }
}
