import UIKit

class ImagePreviewViewController: UIViewController {

    let imagePreviewView = ImagePreviewView()

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imagePreviewView.capturedImageView.image = image
    }

    init(capturedImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = capturedImage
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    private func configureButtons() {
        imagePreviewView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }

    private func setupConstraints() {
        imagePreviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePreviewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagePreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagePreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagePreviewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }

}
