import UIKit

final class MMONewsCell: UITableViewCell {

    static let identifier: String = "MMoNewsCell"

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        return stackView
    }()

    // MARK: Properties
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    // MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: Configuration Methods
    func configureCell(with game: MMOGeneralNewsModel) {
        guard let data = game.thumbnailData else { return }
        thumbnailImageView.image = UIImage(data: data)
        gameNameLabel.text = game.title
    }
}

// MARK: ViewConfiguration
extension MMONewsCell: ViewConfiguration {

    func configViews() {}

    func buildViews() {
        contentView.addSubview(contentStackView)
        [thumbnailImageView, gameNameLabel].forEach(contentStackView.addArrangedSubview)
    }

    func setupConstraints() {
        contentStackView.setAnchorsEqual(to: contentView, .init(top: 12, left: 12, bottom: 12, right: 12))
        contentStackView.centerYEqual(to: contentView)

        thumbnailImageView.size(height: 45, width: 80)
    }
}
