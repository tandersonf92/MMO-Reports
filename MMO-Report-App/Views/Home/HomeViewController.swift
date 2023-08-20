import UIKit

final class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()

    private var lastSearchedPage: Int = 0
    private var isLoading: Bool = false
    private var isBlockedToAppendNewCells: Bool = false

    private var mmos: [MMOInformationModel] = [] {
        didSet {
            DispatchQueue.main.async {
                    self.collectionView.reloadData()
            }
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 60) / 2, height: 120)
        //        layout.sectionInset = UIEdgeInsets(top: 21.5, left: 18, bottom: 21.5, right: 18)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
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
        viewModel.listOfMMos.bind { [weak self] result in
            guard let self = self else { return }
            mmos = result
        }
    }

    private func fetchNewPage() {
        lastSearchedPage += 1
        viewModel.fetchNextPage()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mmos.count == 0 ? 0 : mmos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return .init()
        }
        cell.setupCell(using: mmos[indexPath.row])
        cell.backgroundColor = .darkGray

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("indexPath.row: \(indexPath.row)")

        if isLoading == false {
            if (indexPath.row + 1) % 20 == 0 && indexPath.row != 0  && indexPath.row == mmos.count - 1 {
                fetchNewPage()
            }

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

