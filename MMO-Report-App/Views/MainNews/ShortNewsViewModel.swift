import Foundation

struct MainNewsViewModel {
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
                DispatchQueue.main.async {

                    success.forEach({ news in
                        service.fetchImage(url: news.mainImage, completion: { data in
                            let model = MMOGeneralNewsModel(title: news.title,
                                                            shortDescription: news.shortDescription,
                                                            thumbnail: news.thumbnail,
                                                            mainImage: news.mainImage,
                                                            articleContent: news.articleContent,
                                                            articleUrl: news.articleUrl,
                                                            thumbnailData: data)
                            newsModel.append(model)
                            completion(newsModel)
                        })
                    })
                }
            case .failure(let error):
                print("ERROR fetchNews \(error)")
            }
        }
    }

    func fetchImageData(url: String, completion: @escaping (Data) -> Void ) {
        DispatchQueue.main.async {
            service.fetchImage(url: url) { data in
                completion(data)
            }
        }
    }
}
