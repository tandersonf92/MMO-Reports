import UIKit

final class FavoritesViewController: UIViewController {

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

// MARK: ViewConfiguration
extension FavoritesViewController: ViewConfiguration {
    func configViews() {
        view?.backgroundColor = .green
        title = "Favorites"
    }

    func buildViews() {

    }

    func setupConstraints() {

    }
}
