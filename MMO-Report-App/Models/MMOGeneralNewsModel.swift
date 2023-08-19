import UIKit

struct MMOGeneralNewsResponse: Codable {
    let title: String
    let shortDescription: String
    let thumbnail: String
    let mainImage: String
    let articleContent: String
    let articleUrl: String
}

struct MMOGeneralNewsModel: Codable {
    let title: String
    let shortDescription: String
    let thumbnail: String
    let mainImage: String
    let articleContent: String
    let articleUrl: String
    var thumbnailData: Data?
    var mainImageData: Data?
}
