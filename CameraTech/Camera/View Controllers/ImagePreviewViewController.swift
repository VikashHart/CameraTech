import UIKit

class ImagePreviewViewController: UIViewController {

    let imagePreviewView = ImagePreviewView()

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureScrollView()
        configureButtons()
        configureGestures()
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

    @objc func zoomOut() {
        imagePreviewView.scrollView.zoomScale = 1.0
    }

    private func configureScrollView() {
        imagePreviewView.scrollView.delegate = self
    }

    private func configureButtons() {
        imagePreviewView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }

    private func configureGestures() {
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomOut))
        doubleTap.numberOfTapsRequired = 2
        self.imagePreviewView.scrollView.addGestureRecognizer(doubleTap)
    }

    private func setupConstraints() {
        view.addSubview(imagePreviewView)
        imagePreviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePreviewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagePreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagePreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagePreviewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}

extension ImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePreviewView.capturedImageView
    }
}
