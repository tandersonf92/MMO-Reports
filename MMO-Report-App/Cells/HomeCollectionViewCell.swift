import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {

    static var identifier: String = "HomeCollectionViewCell"

    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .green
        return imageView
    }()

    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    // MARK: Properties

    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: Setup Methods
    func setupCell(using model: MMOInformationModel) {
        gameNameLabel.text = model.title
        mainImage.image = model.thumbnailImage
    }
}

// MARK: ViewConfiguration
extension HomeCollectionViewCell: ViewConfiguration {

    func configViews() {

    }

    func buildViews() {
        addSubview(mainImage)
        addSubview(gameNameLabel)
    }

    func setupConstraints() {
        mainImage.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor)

        gameNameLabel.anchor(top: mainImage.bottomAnchor,
                             leading: leadingAnchor,
                             bottom: bottomAnchor,
//                             trailing: trailingAnchor,
                             paddingTop: 8,
                             paddingBottom: 4,
                             paddingLeft: 0,
                             paddingRight: 0)

        mainImage.size(height: 120)
    }
}
