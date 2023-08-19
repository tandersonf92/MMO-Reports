import UIKit

final class SearchMMOViewController: UIViewController {

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

// MARK: ViewConfiguration
extension SearchMMOViewController: ViewConfiguration {
    func configViews() {
        view.backgroundColor = .yellow
        title = "Home"
    }

    func buildViews() {

    }

    func setupConstraints() {

    }
}

