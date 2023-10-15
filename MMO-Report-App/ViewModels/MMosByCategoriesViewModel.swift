import UIKit
final class MMOsByCategoriesViewModel {
    private let service: MMOListServiceProtocol
    private let imageService = ImageDownloaderService()

    private var limitPerPage: Int = 5
    private var actualPage: Int = 0
    var isLastPage: Bool = false
    var listOfGenres: [Genre] = [.battleRoyale, .martialArts]

    var listOfMMOsByGenre: [MMOListByCategoryModel] = []
    var paginatedMMOs: [Int: MMOInformationModel] = [:]

    var updateListOfMMos: (([MMOListByCategoryModel]) -> Void)?

    init(service: MMOListServiceProtocol = MMOListService()) {
        self.service = service
    }

    func fetchMMOs() { // TODO: Build a Logic to get only 5 images of each category. Later, add by page.
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)

        service.fetchListOfMMOsByListOfGenres(genres: [.battleRoyale, .martialArts]) { [weak self] listOfMMOsWithCategory in
            guard let self = self else { return }
            let listByCategoryModel = listOfMMOsWithCategory.map { MMOListByCategoryModelFactory.convertToModel(response: $0, itemsPerPage: 5) } // TODO: Could be injected
            self.listOfMMOsByGenre = listByCategoryModel

            for selectedGenge in 0..<listOfMMOsByGenre.count {
                for index in 0..<listOfMMOsByGenre[selectedGenge].numberOfPages {
                    group.enter()
                    let selectedMMo = self.listOfMMOsByGenre[selectedGenge].listOfMMOs[index]
                    self.imageService.fetchImage(url: selectedMMo.thumbnail) { imageData in
                        defer { group.leave() }
                        self.listOfMMOsByGenre[selectedGenge].listOfMMOs[index].thumbnailImage = UIImage(data: imageData)
                    }
                }
            }
            group.notify(queue: queue) {
                self.updateListOfMMos?(self.listOfMMOsByGenre)

            }
        } failure: { error in
            print("ErroR ErroR")
        }
    }

    private func getNumberOfPages(numberOfItems: Int, itemsPerPage: Int) -> Int {
        if  numberOfItems < itemsPerPage {
            return 1
        } else if numberOfItems % itemsPerPage == 0 {
            return numberOfItems % itemsPerPage
        } else {
            return (numberOfItems % itemsPerPage) + 1
        }
    }
}
