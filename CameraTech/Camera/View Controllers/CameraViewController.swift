import UIKit

class CameraViewController: UIViewController {

    let cameraPreviewLayer = CameraPreviewLayerView()
    var captureSession: PhotoCaptureable = CaptureSession()

    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        captureSession.configurePreview(view: cameraPreviewLayer.previewLayer)
        setupButtons()
        configureGestures()
        presentPreviewVC()
    }

    @objc func flashMode() {
        cameraPreviewLayer.flashButton.isHidden = true
        cameraPreviewLayer.switchCameraButton.isHidden = true
        cameraPreviewLayer.flashContainerView.isHidden = false
    }

    @objc func flashOn() {
        captureSession.setFlashMode(mode: .on)
        cameraPreviewLayer.flashButton.setImage(UIImage(named: "flash_on")?.withRenderingMode(.alwaysTemplate), for: .normal)
        hideFlashOptions()
    }

    @objc func flashAuto() {
        captureSession.setFlashMode(mode: .auto)
        cameraPreviewLayer.flashButton.setImage(UIImage(named: "flash_auto")?.withRenderingMode(.alwaysTemplate), for: .normal)
        hideFlashOptions()
    }

    @objc func flashOff() {
        captureSession.setFlashMode(mode: .off)
        cameraPreviewLayer.flashButton.setImage(UIImage(named: "flash_off")?.withRenderingMode(.alwaysTemplate), for: .normal)
        hideFlashOptions()
    }

    @objc func switchCamera() {
        captureSession.switchCamera()
    }

    @objc func takePhoto() {
        captureSession.captureImage()
    }

    @objc func handleSingleTap(tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(in: cameraPreviewLayer.previewLayer)
        print("current point: \(point)")
        captureSession.focus(touchLocation: point)
    }

    @objc func handleDoubleTap() {
        captureSession.switchCamera()
    }

    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        let device = captureSession.getDevice()

        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }

        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)

        switch pinch.state {
        case .began: fallthrough
        case .changed: captureSession.updateZoomScaleFactor(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            captureSession.updateZoomScaleFactor(scale: lastZoomFactor)
        default: break
        }
    }

    private func setupButtons() {
        cameraPreviewLayer.shutterButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        cameraPreviewLayer.switchCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        cameraPreviewLayer.flashButton.addTarget(self, action: #selector(flashMode), for: .touchUpInside)
        cameraPreviewLayer.flashOnButton.addTarget(self, action: #selector(flashOn), for: .touchUpInside)
        cameraPreviewLayer.flashAutoButton.addTarget(self, action: #selector(flashAuto), for: .touchUpInside)
        cameraPreviewLayer.flashOffButton.addTarget(self, action: #selector(flashOff), for: .touchUpInside)
    }

    private func configureGestures() {
        // Single Tap
        let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(tapGesture:)))
        singleTap.numberOfTapsRequired = 1
        self.cameraPreviewLayer.previewLayer.addGestureRecognizer(singleTap)

        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.cameraPreviewLayer.previewLayer.addGestureRecognizer(doubleTap)

        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true

        let pinchToZoom: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        self.cameraPreviewLayer.previewLayer.addGestureRecognizer(pinchToZoom)
    }

    func presentPreviewVC() {
        captureSession.onImageCaptured = { [weak self] (image) in
            let imagePreviewVC = ImagePreviewViewController(capturedImage: image)
            self?.present(imagePreviewVC, animated: true, completion: nil)
        }
    }

    private func setupConstraints() {
        view.addSubview(cameraPreviewLayer)
        cameraPreviewLayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraPreviewLayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraPreviewLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraPreviewLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraPreviewLayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    private func hideFlashOptions() {
        cameraPreviewLayer.flashContainerView.isHidden = true
        cameraPreviewLayer.flashButton.isHidden = false
        cameraPreviewLayer.switchCameraButton.isHidden = false
    }
}
