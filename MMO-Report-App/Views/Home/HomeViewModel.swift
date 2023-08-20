import UIKit
final class HomeViewModel {
    
    private let service: ApiServiceProtocol
    
    private var fullMMOs: [MMOInformationResponse] = []
    private var numberOfPages: Int = 0
    private var actualPage: Int = 0
    var isLastPage: Bool = false
    var listOfMMos: ObservableObject<[MMOInformationModel]> = ObservableObject([])

    private var mmosModel: [MMOInformationModel] = [] {
        didSet {
            let itemsInThisPage = isLastPage ? mmosModel.count % 20 : 0
            if mmosModel.count % 20 == itemsInThisPage {
                listOfMMos.value = mmosModel
            }
        }
    }

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
        isLastPage = actualPage == numberOfPages - 1

        let informationsPerPage: Int = isLastPage ? fullMMOs.count % 20 : 20
        var paginatedMMOs: [MMOInformationResponse] = []


        for _ in 1...informationsPerPage {
            paginatedMMOs.append((fullMMOs.removeFirst()))
        }

        paginatedMMOs.enumerated().forEach { index, mmoResponse in

            if index + 1 == informationsPerPage {
                buildCompleteModel(using: paginatedMMOs)
            }
        }
    }

    func fetchNextPage() {
        actualPage += 1
        isLastPage = actualPage == numberOfPages - 1
        let informationsPerPage: Int = isLastPage ? fullMMOs.count % 20 : 20
        var paginatedMMOs: [MMOInformationResponse] = []

        for _ in 1...informationsPerPage {
            paginatedMMOs.append((fullMMOs.removeFirst()))
        }

            buildCompleteModel(using: paginatedMMOs)
    }

    func buildCompleteModel(using response: [MMOInformationResponse]) {
        response.enumerated().forEach { index, mmoResponse in
            service.fetchImage(url: mmoResponse.thumbnail) { data in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let model = HomeViewModelFactory.build(using: mmoResponse, image: UIImage(data: data))
                    mmosModel.append(model)
                }
            }
        }
    }
}

struct HomeViewModelFactory {
    static func build(using response: MMOInformationResponse, image: UIImage? = nil) -> MMOInformationModel {
        MMOInformationModel(title: response.title,
                            thumbnail: response.thumbnail,
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
