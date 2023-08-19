import Foundation

struct ShortNewsViewModel {
    private let service: ApiServiceProtocol
    private var numberOfNews: Int?

    init(service: ApiServiceProtocol) {
        self.service = service
    }

    func searchNews(completion: @escaping ([MMOGeneralNewsModel]) -> Void) {
        var newsModel: [MMOGeneralNewsModel] = [] {
            didSet {
                print(newsModel.count)
                if numberOfNews != nil,
                newsModel.count == numberOfNews {
                    print(newsModel.count)
                }
            }
        }
        service.fetchNews { result in
            switch result {
            case .success(let success):

                print("Success.count: \(success.count)")
                DispatchQueue.main.async {

                    success.forEach({ news in
                        service.fetchImage(url: news.mainImage, completion: { data in

//                            switch data {
//                            case .success(let data):
                                let model = MMOGeneralNewsModel(title: news.title,
                                                                shortDescription: news.shortDescription,
                                                                thumbnail: news.thumbnail,
                                                                mainImage: news.mainImage,
                                                                articleContent: news.articleContent,
                                                                articleUrl: news.articleUrl,
                                                                thumbnailData: data)
                                newsModel.append(model)
                                completion(newsModel)

//                            case .failure(let error):
//                                print("error: \(error)")
//                            }
                        })
                    })

                }
            case .failure:
                print("ERROR")
            }
        }
    }

    func fetchImageData(url: String, completion: @escaping (Data) -> Void ) {
        DispatchQueue.main.async {
            service.fetchImage(url: url) { data in
//                switch data {
//                case .success(let success):
//                    completion(success)
//                case .failure(let _):
//                    break
//                }
                completion(data)
            }
        }
    }
}
