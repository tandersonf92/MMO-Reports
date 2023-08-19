import UIKit

final class HomeTabBarController: UITabBarController {

    private let viewModel = HomeTabBarViewModel()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupViews()
    }

    private func configure() {
//        let tabBarControllers = viewModel.tabControllers
        let tabBarTitles = viewModel.tabTitles
        let tabBarIcons = viewModel.tabIcons

        let mainViewController = UINavigationController(rootViewController: SearchMMOViewController())
        let newsViewController = UINavigationController(rootViewController: ShortNewsViewController())
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())

        let tabBarControllers = [mainViewController, newsViewController, favoritesViewController]

        setViewControllers([mainViewController, newsViewController, favoritesViewController], animated: true)
        guard let items = tabBar.items else { return }

        for x in 0..<items.count {
            items[x].image = tabBarIcons[x]
            tabBarControllers[x].title = tabBarTitles[x]
        }
    }

}



// MARK: ViewConfiguration
extension HomeTabBarController: ViewConfiguration {
    func configViews() {
        tabBar.backgroundColor = .white
    }

    func buildViews() {

    }

    func setupConstraints() {

    }
}

