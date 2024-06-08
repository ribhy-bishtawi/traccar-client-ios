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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color of the view to white
        view.backgroundColor = .white
        
        // Set up UI elements
        setupUI()
        if let identifier = UserDefaults.standard.string(forKey: "device_id_preference") {
            trackingNumberText.text = identifier
        }

        // Ensure the layout is RTL
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            adjustForRTL()
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
        logoImageView.layer.cornerRadius = 50 // Adjust the radius to half of the logo's width/height for a circular shape
        logoImageView.clipsToBounds = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(logoImageView) // Add to imageView instead of view
        
        // Set up container view
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.95) // Slightly transparent
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Set up tracking number label
        trackingNumberLabel.text = "رقم التتبع" // Arabic for "Tracking Number:"
        trackingNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberLabel)
        
        // Set up tracking number text
        trackingNumberText.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberText)
        
        // Set up copy button
        let copyIcon = UIImage(systemName: "doc.on.doc")?.withRenderingMode(.alwaysTemplate)
        copyButton.setImage(copyIcon, for: .normal)
        copyButton.tintColor = .systemBlue
        copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(copyButton)
        
        // Set up record button
        recordButton.setTitle("بدأ التتبع", for: .normal) // Arabic for "Start Tracking"
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
        
        // Set up constraints
        setupConstraints()
    }
    
    func adjustForRTL() {
        trackingNumberLabel.textAlignment = .right
        trackingNumberText.textAlignment = .right
        copyButton.contentHorizontalAlignment = .left
    }
    
    @objc func copyButtonTapped() {
        // Copy the text to the clipboard
        UIPasteboard.general.string = trackingNumberText.text
    }
    
    @objc func recordButtonTapped() {
        let userDefaults = UserDefaults.standard
        
        if recordButton.backgroundColor == UIColor(hex: "#219173") {
            recordButton.backgroundColor = UIColor(hex: "#FB1D1D")
            recordButton.setTitle("إيقاف التتبع", for: .normal) // Arabic for "Stop Tracking"
            // Add recording icon
            let recordingIcon = UIImage(systemName: "record.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(recordingIcon, for: .normal)
            recordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) // Add space between image and text
            recordButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) // Add space between text and image
            
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
            recordButton.setTitle("بدأ التتبع", for: .normal) // Arabic for "Start Tracking"
            // Add pause icon
            let pauseIcon = UIImage(systemName: "pause.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(pauseIcon, for: .normal)
            recordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) // Add space between image and text
            recordButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) // Add space between text and image
            
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
        // Image view constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8) // Image view takes 80% of the screen height
        ])
        
        // Logo image view constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Container view constraints
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            containerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10) // Positioned within the image view
        ])
        
        // Tracking number label constraints
        NSLayoutConstraint.activate([
            trackingNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            trackingNumberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        // Tracking number text constraints
        NSLayoutConstraint.activate([
            trackingNumberText.leadingAnchor.constraint(equalTo: copyButton.trailingAnchor, constant: 10),
            trackingNumberText.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        // Copy button constraints
        NSLayoutConstraint.activate([
            copyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            copyButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            copyButton.widthAnchor.constraint(equalToConstant: 24), // Adjust width for the icon
            copyButton.heightAnchor.constraint(equalToConstant: 24) // Adjust height for the icon
        ])
        
        // Record button constraints
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20), // Space between image view and button
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
