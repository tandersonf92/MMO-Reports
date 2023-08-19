import UIKit

final class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.fetchMMOs { response in
            print(response)
        } error: { error in
            print("ERROR: \(error)")
        }
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

