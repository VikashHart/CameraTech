import UIKit
import AVFoundation

protocol PhotoCaptureable {
    var onImageCaptured: ((UIImage) -> Void)? { get set }

    func getDevice() -> AVCaptureDevice

    func captureImage()

    func configurePreview(view: AVCapturePreviewView)

    func switchCamera()

    func setFlashMode(mode: FlashMode)

    func focus(touchLocation: CGPoint)

    func updateZoomScaleFactor(scale factor: CGFloat)

    func updateOrientation(orientation: AVCaptureVideoOrientation)
}

enum FlashMode {
    case on
    case auto
    case off
}

class CaptureSession: NSObject, PhotoCaptureable, AVCapturePhotoCaptureDelegate {
    private var avSession = AVCaptureSession()

    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?

    private var videoOrientation: AVCaptureVideoOrientation

    private var currentFlashMode: AVCaptureDevice.FlashMode?

    private var photoOutput: AVCapturePhotoOutput?
    private let photoSessionPreset = AVCaptureSession.Preset.photo

    private let sessionQueue = DispatchQueue(label: "session Queue")

    var onImageCaptured: ((UIImage) -> Void)?

    override init() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation != .unknown,
            let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: statusBarOrientation) {
            self.videoOrientation = videoOrientation
        } else {
            self.videoOrientation = .portrait
        }
    }

    private func setupCaptureSession() {
        setupPhotoCaptureSession()
        setupDevices()
        setUpCaptureSessionInput(position: .front)
        setFlashMode(mode: .off)
    }

    func getDevice() -> AVCaptureDevice {
        let device = currentCamera!
        return device
    }

    func captureImage(){
        takePhoto()
    }

    func setFlashMode(mode: FlashMode) {
        guard let camera = currentCamera else { return }
        if camera.hasFlash {
            switch mode {
            case .on:
                currentFlashMode = .on
            case .auto:
                currentFlashMode = .auto
            default:
                currentFlashMode = .off
            }
        }
    }

    func focus(touchLocation: CGPoint) {
        let focusPoint = touchLocation

        if let device = currentCamera {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()
            } catch {
                // Handle errors here
                print("\(error.localizedDescription)")
            }
        }
    }

    func updateZoomScaleFactor(scale factor: CGFloat) {
        if let device = currentCamera {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }

    func configurePreview(view: AVCapturePreviewView) {
        setupCaptureSession()
        setupPreviewLayer(view: view)
        configureOutput()
        startRunningCaptureSession()
    }

    // This function sets up a switch to change the camera in use depending on current position when called.
    private func setUpCaptureSessionInput(position: AVCaptureDevice.Position) {
        switch position {
        case .back:
            currentCamera = backCamera
        case .front:
            currentCamera = frontCamera
        default:
            currentCamera = backCamera
        }

        setupInputOutput()
    }

    //This function will be called when the VC sets up the capture session so that the output connection is set before the first photo is taken so that it doesn't come out black.
    func configureOutput() {
        self.photoOutput?.connection(with: .video)?.videoOrientation = self.videoOrientation
        self.photoOutput?.isHighResolutionCaptureEnabled = true
    }

    // Mark:- @objc functions for buttons
    // This is the function that will be called when the take photo button is pressed.
    @objc func takePhoto() {
        sessionQueue.async {
            guard let flashType = self.currentFlashMode else { return }
            self.photoOutput?.connection(with: .video)?.videoOrientation = self.videoOrientation
            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true
            settings.flashMode = flashType
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }

    // This function switches the camera.
    @objc func switchCamera() {
        guard let currentPosition = currentCamera?.position else { return }
        let newPosition: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        setUpCaptureSessionInput(position: newPosition)
    }

    func updateOrientation(orientation: AVCaptureVideoOrientation) {
        videoOrientation = orientation
    }

    // AVCapturePhotoCaptureDelegate methods. This extension is used because you need to wait until the photo you took "didFinishProcessing" before you can handle the image.
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {

            guard let image = UIImage(data: imageData) else { return }
            onImageCaptured?(image)
        }
    }

    // Mark:- AVCapture Session Setup functions
    // This function sets up the photo capture session as well as the photo ouput instance and its settings.
    private func setupPhotoCaptureSession(){
        avSession.beginConfiguration()
        avSession.sessionPreset = photoSessionPreset
        avSession.commitConfiguration()

        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        avSession.addOutput(photoOutput!)
    }

    // This function allows you to have the application discover the devices camera(s)
    private func setupDevices(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices

        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
    }

    // This function allows you to remove the current camera input in use and to set and enable a new camera input.
    private func setupInputOutput(){
        avSession.beginConfiguration()
        if let currentInput = avSession.inputs.first {
            avSession.removeInput(currentInput)
        }
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            avSession.addInput(captureDeviceInput)
        } catch {
            print(error)
        }
        avSession.commitConfiguration()
    }

    // This function creates a layer in the view that will enable a live feed of what your camera is observing.
    private func setupPreviewLayer(view: AVCapturePreviewView){
        view.avPreviewLayer.session = avSession
        view.avPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.avPreviewLayer.connection?.videoOrientation = videoOrientation
    }

    // Starts running the capture session after you set up the view.
    private func startRunningCaptureSession(){
        avSession.startRunning()
    }
}
