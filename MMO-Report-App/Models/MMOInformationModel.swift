import UIKit

struct MMOInformationResponse: Codable {
    let title: String
    let thumbnail: String
    let short_description: String
    let game_url: String
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let release_date: String
}

struct MMOInformationModel {
    let title: String
    let thumbnail: String
    let thumbnailImage: UIImage?
    let short_description: String
    let game_url: String
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let release_date: String
}

//enum Genre {
//    mmorpg,
//    shooter,
//    strategy,
//    moba,
//    racing,
//    sports,
//    social,
//    sandbox,
//    open-world,
//    survival,
//    pvp,
//    pve,
//    pixel,
//    voxel,
//    zombie,
//    turn-based,
//    first-person,
//    third-Person,
//    top-down,
//    tank,
//    space,
//    sailing,
//    side-scroller,
//    superhero,
//    permadeath,
//    card,
//    battle-royale,
//    mmo,
//    mmofps,
//    mmotps,
//    3d,
//    2d,
//    anime,
//    fantasy,
//    sci-fi,
//    fighting,
//    action-rpg,
//    action,
//    military,
//    martial-arts,
//    flight,
//    low-spec,
//    tower-defense,
//    horror,
//    mmorts
//}

enum Platform {
    case pc,
         browser,
         all
}

enum SortBy {
    case releaseDate,
    popularity,
    alphabetical,
    relevance
}
