struct MMOListByCategoryModel {
    let genre: Genre
    var listOfMMOs: [MMOInformationModel]
}

struct MMOListByCategoryPaginatedModel {
    let genre: Genre
    var listOfMMOs: [MMOInformationModel]
    var listOfPaginatedMMOs: [Int: [MMOInformationModel]]
    var numberOfPages: Int
}

enum MMOListByCategoryModelFactory {
    static func convertToModel(response: MMOListByCategoryResponse) ->MMOListByCategoryModel {
        MMOListByCategoryModel(genre: response.genre,
                               listOfMMOs: convertInformationResponseToModel(response: response.listOfMMOs))
    }

    static func convertInformationResponseToModel(response: [MMOInformationResponse]) -> [MMOInformationModel] {
        response.map { response in
            MMOInformationModel(title: response.title,
                                thumbnail: response.thumbnail,
                                shortDescription: response.shortDescription,
                                gameUrl: response.gameUrl,
                                genre: response.genre,
                                platform: response.platform,
                                publisher: response.publisher,
                                developer: response.developer,
                                releaseDate: response.releaseDate)
        }
    }

    static func convertInformationResponseToPaginatedModel(paginatedList: [Int: [MMOInformationModel]], normalList: [MMOInformationModel], genre: Genre, numberOfPages: Int) -> MMOListByCategoryPaginatedModel {
        MMOListByCategoryPaginatedModel(genre: genre,
                                        listOfMMOs: normalList,
                                        listOfPaginatedMMOs: paginatedList,
                                        numberOfPages: numberOfPages)
    }

    static func getNumberOfPages(numberOfItems: Int, itemsPerPage: Int) -> Int {
        if  numberOfItems < itemsPerPage {
            return 1
        } else if numberOfItems % itemsPerPage == 0 {
            return numberOfItems % itemsPerPage
        } else {
            return (numberOfItems % itemsPerPage) + 1
        }
    }
}
