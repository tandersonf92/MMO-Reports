import UIKit
final class HomeViewModel {
    
    private let service: ApiServiceProtocol
    
    private var fullMMOs: [MMOInformationResponse]?
    private var numberOfPages: Int = 0
    private var actualPage: Int = 0
    private var mmosModel: [MMOInformationModel?] = []
    private var firstPageResponseList:  [MMOInformationResponse] = []
    private var firstPageModelList:  [MMOInformationModel] = [] {
        didSet {
            if firstPageModelList.count == 20 {
                paginatingInformation.value[0] = firstPageModelList
            }
        }
    }
    
    var paginatingInformation: ObservableObject<[Int: [MMOInformationModel]]> = ObservableObject([:])
    var paginatingInformationClone: ObservableObject<[Int: [MMOInformationModel]]> = ObservableObject([:])
    
    init(service: ApiServiceProtocol = APIService()) {
        self.service = service
    }

    func fetchMMOs() {
        service.fetchMMOs(keywords: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                fullMMOs = success
                self.numberOfPages = success.count % 20 == 0 ? success.count / 20 : (success.count / 20) + 1
                DispatchQueue.main.async { [weak self] in
                    self?.setupPagination()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }

    private func setupPagination() {
        guard var fullMMOs = fullMMOs else { return }
        for pageNumber in 0...numberOfPages - 1 {
            let isLastPage: Bool = pageNumber == numberOfPages - 1

            let informationsPerPage: Int = isLastPage ? fullMMOs.count % 20 : 20
            var paginatedMMOs: [MMOInformationResponse] = []
            var mmoModelsPerPage: [MMOInformationModel] = []

            for _ in 1...informationsPerPage {
                paginatedMMOs.append((fullMMOs.removeFirst()))
            }
            paginatedMMOs.enumerated().forEach { index, mmoResponse in
                let model: MMOInformationModel
                if pageNumber == 0 {
                    firstPageResponseList.append(mmoResponse)
                } else {
                    model = buildModelWithoutInitialImage(using: mmoResponse)
                    mmoModelsPerPage.append(model)
                }

                if index + 1 == informationsPerPage {
                    if pageNumber == 0 {
                        buildCompleteModel(using: firstPageResponseList)
                    }
                }
            }
        }
    }

    func fetchNextPage() {
        actualPage += 1
    }

    func buildModelWithoutInitialImage(using response: MMOInformationResponse) -> MMOInformationModel {
        HomeViewModelFactory.build(using: response)
    }

    func buildCompleteModel(using response: [MMOInformationResponse]) {
        response.enumerated().forEach { index, mmoResponse in

            self.service.fetchImage(url: mmoResponse.thumbnail) { data in
                var completeModel: [MMOInformationModel] = []
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    firstPageModelList.append(MMOInformationModel(title: mmoResponse.title,
                                                             thumbnailImage: UIImage(data: data),
                                                             short_description: mmoResponse.short_description,
                                                             game_url: mmoResponse.game_url,
                                                             genre: mmoResponse.genre,
                                                             platform: mmoResponse.platform,
                                                             publisher: mmoResponse.publisher,
                                                             developer: mmoResponse.developer,
                                                             release_date: mmoResponse.release_date))

                    
                }
            }
        }
    }
}

struct HomeViewModelFactory {
    static func build(using response: MMOInformationResponse, image: UIImage? = nil) -> MMOInformationModel {
        MMOInformationModel(title: response.title,
                            thumbnailImage: image,
                            short_description: response.short_description,
                            game_url: response.game_url,
                            genre: response.genre,
                            platform: response.platform,
                            publisher: response.publisher,
                            developer: response.developer,
                            release_date: response.release_date)
    }
}
