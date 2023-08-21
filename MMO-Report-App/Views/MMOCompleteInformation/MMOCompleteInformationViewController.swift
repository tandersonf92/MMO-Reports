import UIKit

final class MMOCompleteInformationViewController: UIViewController {

    private let model: MMOInformationModel

    // MARK: Layout Properties
    private lazy var scrollView: UIScrollView = UIScrollView()

    private lazy var mainContentView: UIView = UIView()

    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = model.thumbnailImage
//        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()


    private lazy var mmoNameLabel: UILabel = {
        let label = UILabel()
        label.text = model.title
        label.font = .boldSystemFont(ofSize: 24)
//        label.textAlignment = .center
        return label
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Genre: \(model.genre)"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = model.shortDescription
        label.font = .italicSystemFont(ofSize: 14)
        return label
    }()

    private lazy var platformLabel: UILabel = {
        let label = UILabel()
        label.text = "Platform(s): \(model.platform)"
        return label
    }()

    private lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.text = "Publisher: \(model.publisher)"
        return label
    }()

    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Release Date: \(model.releaseDate)"
        return label
    }()

    init(model: MMOInformationModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil}

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: ViewConfiguration
extension MMOCompleteInformationViewController: ViewConfiguration {
    func configViews() {
        view.backgroundColor = .white
    }

    func buildViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainContentView)
        mainContentView.addSubview(thumbnailImageView)
        mainContentView.addSubview(contentStackView)
        [mmoNameLabel,
         genreLabel,
         descriptionLabel,
         UIView(),
         platformLabel,
         publisherLabel,
         releaseDateLabel].forEach(contentStackView.addArrangedSubview)
    }

    func setupConstraints() {
        scrollView.setAnchorsEqual(to: view)
        scrollView.equalWidthWithScreen()

        mainContentView.setAnchorsEqual(to: scrollView)
        scrollView.equalsWidth(with: mainContentView)

        mainContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true

//        thumbnailImageView.size(width: 300)
//        thumbnailImageView.anchor(top: mainContentView.safeAreaLayoutGuide.topAnchor, paddingTop: 40)

        thumbnailImageView.anchor(top: mainContentView.safeAreaLayoutGuide.topAnchor,
                                  leading: mainContentView.leadingAnchor,
                                  trailing: mainContentView.trailingAnchor)

//        thumbnailImageView.centerXEqual(to: view)

        contentStackView.anchor(top: thumbnailImageView.bottomAnchor,
                                leading: mainContentView.leadingAnchor,
                                bottom: mainContentView.safeAreaLayoutGuide.bottomAnchor,
                                trailing: mainContentView.trailingAnchor,
                                paddingTop: 12,
                                paddingBottom: 24,
                                paddingLeft: 24,
                                paddingRight: 24)
    }
}
