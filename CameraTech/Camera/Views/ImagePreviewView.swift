import UIKit

class ImagePreviewView: UIView {
    lazy var capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.opacity = 1
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
        setupCapturedImageView()
        setupBackButton()
    }

    private func setupCapturedImageView() {
        addSubview(capturedImageView)
        NSLayoutConstraint.activate([
            capturedImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            capturedImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            capturedImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            capturedImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    private func setupBackButton() {
        capturedImageView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: capturedImageView.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: capturedImageView.leadingAnchor, constant: 10)
            ])
    }

}
