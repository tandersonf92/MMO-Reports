import UIKit

final class HomeViewController: UIViewController {

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

// MARK: ViewConfiguration
extension HomeViewController: ViewConfiguration {
    func configViews() {
        view.backgroundColor = .yellow
        title = "Home"
    }

    func buildViews() {

    }

    func setupConstraints() {

    }
}

