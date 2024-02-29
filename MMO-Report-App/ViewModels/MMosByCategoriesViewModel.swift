import UIKit
final class MMOsByCategoriesViewModel {
    private let service: MMOListServiceProtocol
    private let imageService = ImageDownloaderService()

    private var limitPerPage: Int = 5
    private var actualPage: Int = 0
    var isLastPage: Bool = false
    var listOfGenres: [Genre] = [.battleRoyale, .martialArts]

    var listOfMMOsByGenre: [MMOListByCategoryModel] = []
    var listOfMMOsByGenrePaginated: [MMOListByCategoryModel] = []
    var listOfMMOsPaginatedByCategory: [MMOListByCategoryPaginatedModel] = []
    var paginatedMMOs: [Int: [MMOInformationModel]] = [:]

    var updateListOfMMos: (([MMOListByCategoryModel]) -> Void)?

    init(service: MMOListServiceProtocol = MMOListService()) {
        self.service = service
    }

//    func fetchMMOs() { // TODO: Build a Logic to get only 5 images of each category. Later, add by page.
//        let group = DispatchGroup()
//        let queue = DispatchQueue.global(qos: .userInitiated)
//
//        service.fetchListOfMMOsByListOfGenres(genres: [.battleRoyale, .martialArts]) { [weak self] listOfMMOsWithCategory in
//            guard let self = self else { return }
//            let listByCategoryModel = listOfMMOsWithCategory.map { MMOListByCategoryModelFactory.convertToModel(response: $0) } // TODO: Could be injected
//            self.listOfMMOsByGenre = listByCategoryModel
//
//            for selectedGenge in 0..<listOfMMOsByGenre.count {
//                let numberOfPages = getNumberOfPages(numberOfItems: listByCategoryModel[selectedGenge].listOfMMOs.count, itemsPerPage: limitPerPage)
//                for index in 0..<numberOfPages {
//                    group.enter()
//                    let selectedMMo = self.listOfMMOsByGenre[selectedGenge].listOfMMOs[index]
//                    self.imageService.fetchImage(url: selectedMMo.thumbnail) { imageData in
//                        defer { group.leave() }
//                        self.listOfMMOsByGenre[selectedGenge].listOfMMOs[index].thumbnailImage = UIImage(data: imageData)
//                    }
//                }
//            }
//            group.notify(queue: queue) {
//                self.updateListOfMMos?(self.listOfMMOsByGenre)
//
//            }
//        } failure: { error in
//            print("ErroR ErroR")
//        }
//    }


    func fetchMMOs() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)

        service.fetchListOfMMOsByListOfGenres(genres: [.battleRoyale, .card, .moba, .pixel, .openWorld, .firstPerson, .racing]) { [weak self] listOfMMOsWithCategory in
            guard let self = self else { return }
            for mmosByCategoryIndex in 0..<listOfMMOsWithCategory.count {
                var actualPage: Int = 0
                let listOfResponsesByCategory = MMOListByCategoryModelFactory.convertInformationResponseToModel(response: listOfMMOsWithCategory[mmosByCategoryIndex].listOfMMOs)
                let numberOfPages = getNumberOfPages(numberOfItems: listOfResponsesByCategory.count, itemsPerPage: limitPerPage)
                var arrayOfMMOs: [MMOInformationModel] = []
//                var paginatedMMOs: [Int: [MMOInformationModel]] = [:]
                for modelIndex in 0..<listOfResponsesByCategory.count {
                    arrayOfMMOs.append(listOfResponsesByCategory[modelIndex])

                    if modelIndex % 5 == 0 && modelIndex != 0 {
                        paginatedMMOs[actualPage] = arrayOfMMOs
                        if actualPage == 0 {
                            listOfMMOsByGenrePaginated.append(.init(genre: listOfMMOsWithCategory[mmosByCategoryIndex].genre,
                                                                    listOfMMOs: arrayOfMMOs))
                        }
                        actualPage += 1
                        arrayOfMMOs = []
                    }

                    if mmosByCategoryIndex == listOfMMOsWithCategory.count - 1 {
                        self.listOfMMOsPaginatedByCategory.append(
                            MMOListByCategoryModelFactory.convertInformationResponseToPaginatedModel(paginatedList: paginatedMMOs,
                                                                                                     normalList: arrayOfMMOs,
                                                                                                     genre: listOfMMOsWithCategory[mmosByCategoryIndex].genre,
                                                                                                     numberOfPages: numberOfPages))

                    }
                }
            }

            for categoryIndex in 0..<listOfMMOsWithCategory.count {
                let firstFetchMMOImagesCount = listOfMMOsWithCategory[categoryIndex].listOfMMOs.count < 5 ? listOfMMOsWithCategory[categoryIndex].listOfMMOs.count : 5
                for index in 0..<firstFetchMMOImagesCount {
                    group.enter()
                    let selectedMMo = listOfMMOsWithCategory[categoryIndex].listOfMMOs[index]
                    self.imageService.fetchImage(url: selectedMMo.thumbnail) { imageData in
                        defer { group.leave() }
                        self.listOfMMOsByGenrePaginated[categoryIndex].listOfMMOs[index].thumbnailImage = UIImage(data: imageData)
                       let ggw = self.paginatedMMOs[categoryIndex]

                    }
                }
            }
            group.notify(queue: queue) {
                self.updateListOfMMos?(self.listOfMMOsByGenrePaginated)
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
