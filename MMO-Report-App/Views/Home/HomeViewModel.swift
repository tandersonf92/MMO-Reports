import UIKit
final class HomeViewModel {
    
    private let service: ApiServiceProtocol
    
    private var fullMMOs: [MMOInformationResponse]?
    private var paginatedMMOs: [[MMOInformationResponse]] = [[]]
    private var numberOfPages: Int?
    private var actualPage: Int = 0
    private var mmosModel: [MMOInformationModel?] = []
    
    var paginatingInformation: ObservableObject<[Int: [MMOInformationModel]]> = ObservableObject([:]) //criar um observer para ele
    
    init(service: ApiServiceProtocol = APIService()) {
        self.service = service
    }
    
//    func fetchMMOs(completion: @escaping ([MMOInformationModel]) -> Void, error: @escaping (ApiError) -> Void) {
//        service.fetchMMOs(keywords: nil) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let success):
//                print("success.count: \(success.count)")
//                fullMMOs = success
//                self.numberOfPages = success.count % 20 == 0 ? success.count / 20 : (success.count / 20) + 1
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self,
//                          let finalModelArray = self.setupPaginationAndGetModelList() else { return }
//                    completion(finalModelArray)
//                }
//                //                self.setupPagination()
//                //                guard let model = paginatingInformation[self.actualPage] else {
//                //                    print(paginatingInformation[self.actualPage])
//                //                    error(.decodingError(description: "INVALID MODEL"))
//                //                    return
//                //                }
//                //                completion(model)
//                actualPage += 1
//            case .failure(let failure):
//                error(failure)
//            }
//        }
//    }

    func fetchMMOs() {
        service.fetchMMOs(keywords: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                print("success.count: \(success.count)")
                print(success[0])
                fullMMOs = success
                self.numberOfPages = success.count % 20 == 0 ? success.count / 20 : (success.count / 20) + 1
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self, let finalModelArray = self.setupPaginationAndGetModelList() else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.setupPaginationAndGetModelList2()
                }

            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func setupPaginationAndGetModelList() {
        guard var fullMMOs = fullMMOs else { return }
        let informationsPerPage: Int = 20
        var paginatedMMOs: [MMOInformationResponse] = []

        for _ in 1..<informationsPerPage {
            paginatedMMOs.append((fullMMOs.removeFirst()))
        } // aqui ja tenho no paginatedMMOs os 20 primeiros que vao estar na home, mas n tenho imagens ainda

//        mmosModel = paginatedMMOs.enumerated().map { index, mmo in
//            return convertToModelAndSetImage(to: mmo)
//        }

        paginatedMMOs.enumerated().forEach { index, mmoResponse in
            service.fetchImage(url: mmoResponse.thumbnail) { [weak self ]data in
               let model = HomeViewModelFactory.build(using: mmoResponse, image: UIImage(data: data))
                self?.mmosModel.append(model)
            }
        }

        let modelWithNotNilValues = mmosModel.compactMap({ $0 })

        paginatingInformation.value[actualPage] = modelWithNotNilValues
    }

    private func setupPaginationAndGetModelList2() {
        guard var fullMMOs = fullMMOs else { return }
        let informationsPerPage: Int = 20
        var paginatedMMOs: [MMOInformationResponse] = []

        for _ in 1...informationsPerPage {
            paginatedMMOs.append((fullMMOs.removeFirst()))
        } // aqui ja tenho no paginatedMMOs os 20 primeiros que vao estar na home, mas n tenho imagens ainda

        paginatedMMOs.enumerated().forEach { index, mmoResponse in
            service.fetchImage(url: mmoResponse.thumbnail) { [weak self] data in
                guard let self = self else { return }
                let model = HomeViewModelFactory.build(using: mmoResponse, image: UIImage(data: data))
                self.mmosModel.append(model)
//                print("INDEX: \(index)")
//                print("paginatedMMOs.count: \(paginatedMMOs.count)")
//                print("mmosModel: \(mmosModel)")
                print("self.mmosModel.compactMap({ $0 }): \(self.mmosModel.compactMap({ $0 }))")
                if index + 1 == paginatedMMOs.count {
                    paginatingInformation.value[self.actualPage] = self.mmosModel.compactMap({ $0 })
                }
            }
        }

        let modelWithNotNilValues = mmosModel.compactMap({ $0 })

        paginatingInformation.value[actualPage] = modelWithNotNilValues
    }
    
//    private func convertToModelAndSetImage(to mmo: MMOInformationResponse) {
//        var model: MMOInformationModel?
//        service.fetchImage(url: mmo.thumbnail) { data in
//            model = HomeViewModelFactory.build(using: mmo, image: UIImage(data: data))
//        }
//    }

//    private func getMMOList() -> [MMOInformationModel]? {
//        guard let model = paginatingInformation.value[actualPage] else {
//            print(paginatingInformation.value[actualPage])
//            return .init()
//        }
//        return model
//    }
}


struct HomeViewModelFactory {
    static func build(using response: MMOInformationResponse, image: UIImage?) -> MMOInformationModel {
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
