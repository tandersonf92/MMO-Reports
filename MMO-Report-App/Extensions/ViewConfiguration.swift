protocol ViewConfiguration {
    func configViews()
    func buildViews()
    func setupConstraints()
    func setupViews()
}

extension ViewConfiguration {
    func setupViews() {
        configViews()
        buildViews()
        setupConstraints()
    }
}
