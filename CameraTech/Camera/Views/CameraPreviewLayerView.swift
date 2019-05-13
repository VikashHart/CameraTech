import UIKit

class CameraPreviewLayerView: UIView {

    lazy var previewLayer: AVCapturePreviewView = {
        let view = AVCapturePreviewView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var frameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.cyan.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var shutterContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var shutterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "shutter_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var flashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "flash_off")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.opacity = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var switchCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "switch_camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.opacity = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var flashContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(1)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var leftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var flashOnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Flash on", for: .normal)
        button.setImage(UIImage(named: "flash_on")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.opacity = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var flashAutoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Flash auto", for: .normal)
        button.setImage(UIImage(named: "flash_auto")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.layer.opacity = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var flashOffButton: UIButton = {
        let button = UIButton()
        button.setTitle("Flash off", for: .normal)
        button.setImage(UIImage(named: "flash_off")?.withRenderingMode(.alwaysTemplate), for: .normal)
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
        setupPreviewLayer()
        setupFrameView()
        setupShutterContainer()
        setupShutterButton()
        setupButtonContainer()
        setupFlashButton()
        setupSwitchCameraButton()
        setupFlashContainer()
        setupMiddleView()
        setupLeftView()
        setupRightView()
        setupFlashOnButton()
        setupFlashAutoButton()
        setupFlashOffButton()
    }

    private func setupPreviewLayer() {
        addSubview(previewLayer)
        NSLayoutConstraint.activate([
            previewLayer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            previewLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewLayer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    private func setupFrameView() {
        previewLayer.addSubview(frameView)
        NSLayoutConstraint.activate([
            frameView.centerXAnchor.constraint(equalTo: previewLayer.centerXAnchor),
            frameView.centerYAnchor.constraint(equalTo: previewLayer.centerYAnchor),
            frameView.heightAnchor.constraint(equalToConstant: 0),
            frameView.widthAnchor.constraint(equalToConstant: 0)
            ])
    }

    private func setupShutterContainer() {
        previewLayer.addSubview(shutterContainer)
        NSLayoutConstraint.activate([
            shutterContainer.bottomAnchor.constraint(equalTo: previewLayer.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            shutterContainer.centerXAnchor.constraint(equalTo: previewLayer.centerXAnchor),
            shutterContainer.heightAnchor.constraint(equalToConstant: 60),
            shutterContainer.widthAnchor.constraint(equalToConstant: 60)
            ])
    }

    private func setupShutterButton() {
        shutterContainer.addSubview(shutterButton)
        NSLayoutConstraint.activate([
            shutterButton.topAnchor.constraint(equalTo: shutterContainer.topAnchor),
            shutterButton.leadingAnchor.constraint(equalTo: shutterContainer.leadingAnchor),
            shutterButton.trailingAnchor.constraint(equalTo: shutterContainer.trailingAnchor),
            shutterButton.bottomAnchor.constraint(equalTo: shutterContainer.bottomAnchor)
            ])
    }

    private func setupButtonContainer() {
        previewLayer.addSubview(buttonContainerView)
        NSLayoutConstraint.activate([
            buttonContainerView.topAnchor.constraint(equalTo: previewLayer.topAnchor),
            buttonContainerView.leadingAnchor.constraint(equalTo: previewLayer.leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: previewLayer.trailingAnchor),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }

    private func setupFlashButton() {
        buttonContainerView.addSubview(flashButton)
        NSLayoutConstraint.activate([
            flashButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 10),
            flashButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            flashButton.heightAnchor.constraint(equalToConstant: 40),
            flashButton.widthAnchor.constraint(equalToConstant: 40)
            ])
    }

    private func setupSwitchCameraButton() {
        buttonContainerView.addSubview(switchCameraButton)
        NSLayoutConstraint.activate([
            switchCameraButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -10),
            switchCameraButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 40),
            switchCameraButton.widthAnchor.constraint(equalToConstant: 40)
            ])
    }

    private func setupFlashContainer() {
        buttonContainerView.addSubview(flashContainerView)
        NSLayoutConstraint.activate([
            flashContainerView.topAnchor.constraint(equalTo: buttonContainerView.safeAreaLayoutGuide.topAnchor),
            flashContainerView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            flashContainerView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            flashContainerView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
            ])
    }

    private func setupMiddleView() {
        flashContainerView.addSubview(middleView)
        NSLayoutConstraint.activate([
            middleView.centerYAnchor.constraint(equalTo: flashContainerView.centerYAnchor),
            middleView.centerXAnchor.constraint(equalTo: flashContainerView.centerXAnchor),
            middleView.widthAnchor.constraint(equalTo: flashContainerView.widthAnchor, multiplier: 0.33),
            middleView.heightAnchor.constraint(equalTo: flashContainerView.heightAnchor)
            ])
    }

    private func setupLeftView() {
        flashContainerView.addSubview(leftView)
        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: flashContainerView.topAnchor),
            leftView.leadingAnchor.constraint(equalTo: flashContainerView.leadingAnchor),
            leftView.trailingAnchor.constraint(equalTo: middleView.leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: flashContainerView.bottomAnchor)
            ])
    }

    private func setupRightView() {
        flashContainerView.addSubview(rightView)
        NSLayoutConstraint.activate([
            rightView.topAnchor.constraint(equalTo: flashContainerView.topAnchor),
            rightView.leadingAnchor.constraint(equalTo: middleView.trailingAnchor),
            rightView.trailingAnchor.constraint(equalTo: flashContainerView.trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: flashContainerView.bottomAnchor)
            ])
    }

    private func setupFlashOnButton() {
        flashContainerView.addSubview(flashOnButton)
        NSLayoutConstraint.activate([
            flashOnButton.centerYAnchor.constraint(equalTo: leftView.centerYAnchor),
            flashOnButton.centerXAnchor.constraint(equalTo: leftView.centerXAnchor),
            flashOnButton.widthAnchor.constraint(equalToConstant: 40),
            flashOnButton.heightAnchor.constraint(equalToConstant: 40)
            ])

    }

    private func setupFlashAutoButton() {
        middleView.addSubview(flashAutoButton)
        NSLayoutConstraint.activate([
            flashAutoButton.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),
            flashAutoButton.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            flashAutoButton.widthAnchor.constraint(equalToConstant: 40),
            flashAutoButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }

    private func setupFlashOffButton() {
        rightView.addSubview(flashOffButton)
        NSLayoutConstraint.activate([
            flashOffButton.centerYAnchor.constraint(equalTo: rightView.centerYAnchor),
            flashOffButton.centerXAnchor.constraint(equalTo: rightView.centerXAnchor),
            flashOffButton.widthAnchor.constraint(equalToConstant: 40),
            flashOffButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}
