struct MMOListByCategoryModel {
    let genre: Genre
    var listOfMMOs: [MMOInformationModel]
    var numberOfPages: Int
}

enum MMOListByCategoryModelFactory {
    static func convertToModel(response: MMOListByCategoryResponse, itemsPerPage: Int) ->MMOListByCategoryModel {
        MMOListByCategoryModel(genre: response.genre,
                               listOfMMOs: convertInformationResponseToModel(response: response.listOfMMOs),
                               numberOfPages: getNumberOfPages(numberOfItems: response.listOfMMOs.count, itemsPerPage: itemsPerPage))
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
