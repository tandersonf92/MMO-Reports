import UIKit

final class CategoriesSectionViewController: UIViewController {

    var isFirstCall: Bool = true

    private var mmosPerGenre: [MMOListByCategoryModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private let viewModel = MMOsByCategoriesViewModel()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40), height: 200)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CategorySectionViewCell.self, forCellWithReuseIdentifier: CategorySectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinders()
        viewModel.fetchMMOs()
        setupViews()
    }

    private func setupBinders() {
        viewModel.updateListOfMMos = { [weak self] listOfMMos in
            self?.mmosPerGenre = listOfMMos
        }
    }

    private func fetchNewPage() {}
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension CategoriesSectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mmosPerGenre.count == 0 ? 0 : mmosPerGenre.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySectionViewCell.identifier, for: indexPath) as? CategorySectionViewCell else {
            return .init()
        }
        cell.delegate = self
        cell.setupCell(using: mmosPerGenre[indexPath.row])
        cell.backgroundColor = .darkGray
        return cell
    }
}
// MARK: CategorySectionViewCellDelegateProtocol
extension CategoriesSectionViewController: CategorySectionViewCellDelegateProtocol {
    func presentInformationScreen(viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

// MARK: ViewConfiguration
extension CategoriesSectionViewController: ViewConfiguration {
    func configViews() {
        view.backgroundColor = .yellow
        title = "Categories"
    }

    func buildViews() {
        view.addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView.setAnchorsEqual(to: view,
                                       .init(top: 24,
                                             left: 24,
                                             bottom: 24,
                                             right: 24),
                                       safe: true)
    }
}

