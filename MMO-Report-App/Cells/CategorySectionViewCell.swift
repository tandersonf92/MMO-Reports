import UIKit

protocol CategorySectionViewCellDelegateProtocol: AnyObject {
    func presentInformationScreen(viewController: UIViewController)
}

final class CategorySectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "CategorySectionViewCell"

    weak var delegate: CategorySectionViewCellDelegateProtocol?
    
    private var categoryModel: MMOListByCategoryModel?  {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var titleLabel: UILabel = UILabel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 170)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(SingleImageViewCell.self, forCellWithReuseIdentifier: SingleImageViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: Setup Methods
    func setupCell(using model: MMOListByCategoryModel) {
        titleLabel.text = model.genre.rawValue
        categoryModel = model
    }
}

extension CategorySectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryModel?.listOfMMOs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleImageViewCell.identifier, for: indexPath) as? SingleImageViewCell else {
            return .init()
        }
        cell.configureCell(with: categoryModel?.listOfMMOs[indexPath.row].thumbnailImage)
        return cell
    }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let model = categoryModel?.listOfMMOs[indexPath.row] else { return }
            let vc = MMOCompleteInformationViewController(model: model)
            delegate?.presentInformationScreen(viewController: vc)
//            present(vc, animated: true)
        }
}

// MARK: ViewConfiguration
extension CategorySectionViewCell: ViewConfiguration {
    
    func configViews() {
        
    }
    
    func buildViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor)
        
        collectionView.anchor(top: titleLabel.bottomAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              paddingTop: 8,
                              paddingBottom: 4,
                              paddingLeft: 0,
                              paddingRight: 0)

    }
}
