import UIKit

class ImagePreviewView: UIView {

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .black
        sv.delaysContentTouches = false
        sv.zoomScale = 1.0
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 3.0
        sv.alwaysBounceVertical = true
        sv.alwaysBounceHorizontal = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var backButtoncontainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        setupScrollView()
        setupContainerView()
        setupCapturedImageView()
        setupBackButtonContainer()
        setupBackButton()
    }

    private func setupScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }

    private func setupContainerView() {
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
            ])
    }

    private func setupCapturedImageView() {
        containerView.addSubview(capturedImageView)
        NSLayoutConstraint.activate([
            capturedImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            capturedImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            capturedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            capturedImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
    }

    private func setupBackButtonContainer() {
        containerView.addSubview(backButtoncontainer)
        NSLayoutConstraint.activate([
            backButtoncontainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            backButtoncontainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButtoncontainer.heightAnchor.constraint(equalToConstant: 40),
            backButtoncontainer.widthAnchor.constraint(equalToConstant: 40)
            ])
    }

    private func setupBackButton() {
        backButtoncontainer.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: backButtoncontainer.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: backButtoncontainer.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: backButtoncontainer.trailingAnchor),
            backButton.bottomAnchor.constraint(equalTo: backButtoncontainer.bottomAnchor)
            ])
    }
}

