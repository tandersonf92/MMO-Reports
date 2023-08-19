import UIKit
import WebKit

final class FullNoticeViewController: UIViewController {

    private let noticeUrl: String

    private lazy var webView = WKWebView()

    init(noticeUrl: String) {
        self.noticeUrl = noticeUrl
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadUrl()
    }

    private func loadUrl() {
        webView.allowsBackForwardNavigationGestures = true
        guard let url = URL(string: noticeUrl) else { return }
        webView.load(URLRequest(url: url))
    }
}

// MARK: ViewConfiguration
extension FullNoticeViewController: ViewConfiguration {
    func configViews() {}

    func buildViews() {
        view.addSubview(webView)
    }

    func setupConstraints() {
        webView.setAnchorsEqual(to: view)
    }
}

