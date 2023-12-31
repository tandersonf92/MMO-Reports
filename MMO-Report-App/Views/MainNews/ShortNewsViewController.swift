//
//  ViewController.swift
//  MMO-Report-App
//
//  Created by Anderson Oliveira on 16/08/23.
//

import UIKit

final class MainNewsViewController: UIViewController {

    private let viewModel = MainNewsViewModel(service:  APIService())

    var news: [MMOGeneralNewsModel] = [] {

        didSet {
            print(news.count)
            if news.count % 3 == 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MMONewsCell.self, forCellReuseIdentifier: MMONewsCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNews()
    }

    private func updateNews() {
        viewModel.searchNews { [weak self] response in
            self?.news = response
        }
    }
}

extension MainNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MMONewsCell.identifier, for: indexPath) as? MMONewsCell else { return .init() }
            cell.configureCell(with: self.news[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedNewsModel = news[indexPath.row]

        viewModel.fetchImageData(url:selectedNewsModel.mainImage) { [weak self] data in
            DispatchQueue.main.async { [weak self] in
                selectedNewsModel.mainImageData = data
                let viewController = CompleteNewsViewController(model: selectedNewsModel)
                self?.present(viewController, animated: true)
            }
        }
    }
}

// MARK: View Configuration
extension MainNewsViewController: ViewConfiguration {
    func configViews() {
        view.backgroundColor = .white
        title = "News"
    }

    func buildViews() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.setAnchorsEqual(to: view,
                                  .init(top: 40,
                                        left: 0,
                                        bottom: 24,
                                        right: 0),
                                  safe: true)
    }
}
