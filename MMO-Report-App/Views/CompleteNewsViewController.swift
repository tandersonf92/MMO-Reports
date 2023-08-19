import UIKit
import WebKit

final class CompleteNewsViewController: UIViewController {

    private var fullNoticeLink: String?

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private lazy var imageContentView: UIView = UIView()

    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var labelContainerControl: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(openNoticeOnWebView), for: .touchUpInside)
        return control
    }()

    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.text = "Read the full notice HERE"
        return label
    }()

    init(model: MMOGeneralNewsModel) {
        super.init(nibName: nil, bundle: nil)
        configureNewsVC(with: model)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func configureNewsVC(with model: MMOGeneralNewsModel) {
        guard let imageData = model.mainImageData else { return }
        titleLabel.text = model.title
        descriptionLabel.text = model.shortDescription
        mainImageView.image = UIImage(data: imageData)
        fullNoticeLink = model.articleUrl
    }

    // MARK: Selectors
    @objc private func openNoticeOnWebView() {
        guard let fullNoticeLink = fullNoticeLink else { return }
        let webViewController = FullNoticeViewController(noticeUrl: fullNoticeLink)
        present(webViewController, animated: true)

    }
}

// MARK: ViewConfiguration
extension CompleteNewsViewController: ViewConfiguration {
    func configViews() {
        view.backgroundColor = .white
        linkLabel.isUserInteractionEnabled = false
    }

    func buildViews() {
        view.addSubview(contentStackView)
        [imageContentView,
         titleLabel,
         descriptionLabel,
         labelContainerControl].forEach(contentStackView.addArrangedSubview)
        imageContentView.addSubview(mainImageView)
        labelContainerControl.addSubview(linkLabel)
    }

    func setupConstraints() {
        contentStackView.setAnchorsEqual(to: view,
                                   .init(top: 24,
                                         left: 24,
                                         bottom: 24,
                                         right: 24),
                                   safe: true)

        mainImageView.centerXEqual(to: imageContentView)
        mainImageView.size(height: 150, width: 218)

        mainImageView.anchor(top: imageContentView.topAnchor,
                             bottom: imageContentView.bottomAnchor)

        linkLabel.setAnchorsEqual(to: labelContainerControl)
    }
}

