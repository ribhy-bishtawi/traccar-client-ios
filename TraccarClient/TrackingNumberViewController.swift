import UIKit

class TrackingNumberViewController: UIViewController {
    
    let imageView = UIImageView()
    let logoImageView = UIImageView()
    let containerView = UIView()
    let trackingNumberLabel = UILabel()
    let trackingNumberText = UILabel()
    let copyButton = UIButton(type: .system)
    let recordButton = UIButton(type: .system)
    var rippleLayer: CAReplicatorLayer?
    let navigateButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color of the view to white
        view.backgroundColor = .white
        
        // Set up UI elements
        setupUI()
        if let identifier = UserDefaults.standard.string(forKey: "device_id_preference") {
            trackingNumberText.text = identifier
        }

        // Add observer for app becoming active
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLogoPosition()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIBasedOnTrackingStatus()
    }

    @objc func appDidBecomeActive() {
        updateUIBasedOnTrackingStatus()
    }

    func updateUIBasedOnTrackingStatus() {
        let userDefaults = UserDefaults.standard
        let isTrackingActive = userDefaults.bool(forKey: "service_status_preference")
        
        if isTrackingActive {
            print("Tracking is active")
            recordButton.backgroundColor = UIColor(hex: "#FB1D1D")
            recordButton.setTitle(NSLocalizedString("Stop tracking", comment: ""), for: .normal) // Arabic for "Stop Tracking"
            let recordingIcon = UIImage(systemName: "stop.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(recordingIcon, for: .normal)
            startRippleEffect()
        } else {
            print("Tracking is not active")
            recordButton.backgroundColor = UIColor(hex: "#219173")
            recordButton.setTitle(NSLocalizedString("Start tracking", comment: ""), for: .normal) // Arabic for "Start Tracking"
            let pauseIcon = UIImage(systemName: "pause.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(pauseIcon, for: .normal)
            stopRippleEffect()
        }
    }

    func setupUI() {
        // Set up image view
        imageView.image = UIImage(named: "Background") // Replace with your image name
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Set up logo image view
        logoImageView.image = UIImage(named: "logo") // Replace with your logo image name
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 100 // Adjust the radius to half of the logo's width/height for a circular shape
        logoImageView.clipsToBounds = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(logoImageView) // Add to imageView instead of view
        
        // Set up container view
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.95) // Slightly transparent
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Set up tracking number label
        trackingNumberLabel.text = NSLocalizedString("Tracking number", comment: "") // Arabic for "Tracking Number:"
        trackingNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberLabel)

        // Set up tracking number text
        trackingNumberText.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberText)
        
        // Set up copy button
        let customIcon = UIImage(named: "copy_icon")?.withRenderingMode(.alwaysTemplate)
        copyButton.setImage(customIcon, for: .normal)
        copyButton.tintColor = UIColor(hex: "#D9D9D9") // Change to your desired color
        copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(copyButton)
        
        // Set up record button
        recordButton.setTitle(NSLocalizedString("Start tracking", comment: ""), for: .normal) // Arabic for "Start Tracking"
        recordButton.backgroundColor = UIColor(hex: "#219173")
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20) // Add space between text and image
        recordButton.layer.cornerRadius = 10 // Half of the height to make it fully rounded
        recordButton.clipsToBounds = true
        recordButton.tintColor = .white // Set the tint color to white

        let pauseIcon = UIImage(systemName: "pause.circle.fill")?.withRenderingMode(.alwaysTemplate)
        recordButton.setImage(pauseIcon, for: .normal)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        recordButton.semanticContentAttribute = .forceRightToLeft // To force icon on the left
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)
        
        // Set up navigate button
        navigateButton.setTitle(NSLocalizedString("Settings", comment: ""), for: .normal)
        navigateButton.backgroundColor = UIColor.white
        navigateButton.setTitleColor(.black, for: .normal)
        navigateButton.layer.cornerRadius = 10
        navigateButton.clipsToBounds = true
        navigateButton.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside)
        navigateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigateButton)

        // Set up constraints
        setupConstraints()
    }
    
    @objc func navigateButtonTapped() {
        let nextViewController = MainViewController() // Replace with your next view controller
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    func adjustForRTL() {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            trackingNumberLabel.textAlignment = .right
            trackingNumberText.textAlignment = .right
            copyButton.contentHorizontalAlignment = .left
        } else {
            trackingNumberLabel.textAlignment = .left
            trackingNumberText.textAlignment = .left
            copyButton.contentHorizontalAlignment = .left
        }
    }

    @objc func copyButtonTapped() {
        // Copy the text to the clipboard
        UIPasteboard.general.string = trackingNumberText.text
    }
    
    @objc func recordButtonTapped() {
        let userDefaults = UserDefaults.standard
        
        if recordButton.backgroundColor == UIColor(hex: "#219173") {
            recordButton.backgroundColor = UIColor(hex: "#FB1D1D")
            recordButton.setTitle(NSLocalizedString("Stop tracking", comment: ""), for: .normal) // Arabic for "Stop Tracking"
            // Add recording icon
            let recordingIcon = UIImage(systemName: "stop.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(recordingIcon, for: .normal)
            recordButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20) // Add space between text and image

            // Start tracking
            let url = userDefaults.string(forKey: "server_url_preference")
            let frequency = userDefaults.integer(forKey: "frequency_preference")
            
            let candidateUrl = NSURL(string: url ?? "")
            
            if candidateUrl == nil || candidateUrl?.host == nil || (candidateUrl?.scheme != "http" && candidateUrl?.scheme != "https") {
                showError("Invalid server URL")
            } else if frequency <= 0 {
                showError("Invalid frequency value")
            } else {
                AppDelegate.instance.trackingController = TrackingController()
                AppDelegate.instance.trackingController?.start()
                userDefaults.setValue(true, forKey: "service_status_preference")
                
                // Start ripple effect
                startRippleEffect()
            }
            
        } else {
            recordButton.backgroundColor = UIColor(hex: "#219173")
            recordButton.setTitle(NSLocalizedString("Start tracking", comment: ""), for: .normal) // Arabic for "Start Tracking"
            // Add pause icon
            let pauseIcon = UIImage(systemName: "pause.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(pauseIcon, for: .normal)
            recordButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20) // Add space between text and image

            // Stop tracking
            AppDelegate.instance.trackingController?.stop()
            AppDelegate.instance.trackingController = nil
            userDefaults.setValue(false, forKey: "service_status_preference")
            
            // Stop ripple effect
            stopRippleEffect()
        }
    }

    func startRippleEffect() {
        rippleLayer?.removeFromSuperlayer() // Remove existing ripple layer if any
        
        let rippleLayer = CAReplicatorLayer()
        rippleLayer.frame = view.bounds
        view.layer.insertSublayer(rippleLayer, below: logoImageView.layer)
        
        
        let circle = CALayer()
        circle.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        circle.position = logoImageView.center
        circle.cornerRadius = 50
        circle.borderColor = UIColor.white.cgColor // Change to white color
        circle.borderWidth = 2
        circle.opacity = 0
        rippleLayer.addSublayer(circle)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 4.0 // Increase the scale value to reach more space
        animation.duration = 3.0 // Increase the duration to make the circle stay longer
        animation.repeatCount = .infinity
        circle.add(animation, forKey: "rippleEffect")
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 3.0 // Match the duration to the scale animation
        opacityAnimation.repeatCount = .infinity
        circle.add(opacityAnimation, forKey: "rippleOpacity")
        
        rippleLayer.instanceCount = 3
        rippleLayer.instanceDelay = 1.0 // Increase the delay between each circle
        
        self.rippleLayer = rippleLayer
    }

    func stopRippleEffect() {
        rippleLayer?.removeFromSuperlayer()
        rippleLayer = nil
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: nil, message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            UserDefaults.standard.setValue(nil, forKey: "service_status_preference")
        })
        alert.addAction(defaultAction)
        present(alert, animated: true)
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        // Container view constraints to overlay over the image view at the bottom
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            containerView.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -20) // Space above the record button
        ])
        
        NSLayoutConstraint.activate([
            trackingNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            trackingNumberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            trackingNumberText.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -10),
            trackingNumberText.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            copyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            copyButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            copyButton.widthAnchor.constraint(equalToConstant: 24),
            copyButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Record button constraints to ensure it is fully visible and within the safe area
        NSLayoutConstraint.activate([
            recordButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            recordButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            recordButton.bottomAnchor.constraint(equalTo: navigateButton.topAnchor, constant: -10) // Space above the navigate button
        ])
        
        // Navigate button constraints to position it above the safe area
        NSLayoutConstraint.activate([
            navigateButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            navigateButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            navigateButton.heightAnchor.constraint(equalToConstant: 50),
            navigateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20) // Ensuring it's above the safe area bottom
        ])
    }


    func updateLogoPosition() {
        // Adjust centerYAnchor based on the actual size of imageView
        let centerYConstraint = logoImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -imageView.frame.size.height * 0.25)
        centerYConstraint.isActive = true
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
