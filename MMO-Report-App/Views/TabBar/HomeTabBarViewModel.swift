import UIKit


struct HomeTabBarViewModel {
    var tabIcons: [UIImage?] {
        [UIImage(systemName: "house"),
         UIImage(systemName: "calendar"),
         UIImage(systemName: "star")]
    }

    var tabTitles: [String] {
        ["Home", "News", "Favorites"]
    }

    var tabControllers: [UIViewController] {
        [HomeViewController(),
         MainNewsViewController(),
         FavoritesViewController()]
    }
}
