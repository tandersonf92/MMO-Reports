import UIKit

final class SingleImageViewCell: UICollectionViewCell {

    static let identifier: String = "SingleImageViewCell"

    // MARK: Properties
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: Configuration Methods
    func configureCell(with image: UIImage?) {
        guard let image = image else { return }
        mainImageView.image = image
    }
}

// MARK: ViewConfiguration
extension SingleImageViewCell: ViewConfiguration {

    func configViews() {}

    func buildViews() {
        contentView.addSubview(mainImageView)
    }

    func setupConstraints() {
        mainImageView.setAnchorsEqual(to: contentView)
    }
}
