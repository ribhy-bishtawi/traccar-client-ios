import UIKit

class TrackingNumberViewController: UIViewController {
    
    let imageView = UIImageView()
    let containerView = UIView()
    let trackingNumberLabel = UILabel()
    let trackingNumberText = UILabel()
    let copyButton = UIButton(type: .system)
    let recordButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color of the view to white
        view.backgroundColor = .white
        
        // Set up UI elements
        setupUI()
        
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
        
        // Set up container view
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.95) // Slightly transparent
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Set up tracking number label
        trackingNumberLabel.text = "رقم التتبع:" // Arabic for "Tracking Number:"
        trackingNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberLabel)
        
        // Set up tracking number text
        trackingNumberText.text = "123456"
        trackingNumberText.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberText)
        
        // Set up copy button
        copyButton.setTitle("نسخ", for: .normal) // Arabic for "Copy"
        copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(copyButton)
        
        // Set up record button
        recordButton.setTitle("إيقاف", for: .normal) // Arabic for "Pause"
        recordButton.backgroundColor = UIColor(hex: "#219173")
        recordButton.setTitleColor(.white, for: .normal)
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
        if recordButton.backgroundColor == UIColor(hex: "#219173") {
            recordButton.backgroundColor = UIColor(hex: "#FB1D1D")
            recordButton.setTitle("تسجيل", for: .normal) // Arabic for "Recording"
            // Add recording icon
            let recordingIcon = UIImage(systemName: "record.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(recordingIcon, for: .normal)
        } else {
            recordButton.backgroundColor = UIColor(hex: "#219173")
            recordButton.setTitle("إيقاف", for: .normal) // Arabic for "Pause"
            // Add pause icon
            let pauseIcon = UIImage(systemName: "pause.circle.fill")?.withRenderingMode(.alwaysTemplate)
            recordButton.setImage(pauseIcon, for: .normal)
        }
    }

    func setupConstraints() {
        // Image view constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8) // Image view takes 80% of the screen height
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
            copyButton.trailingAnchor.constraint(equalTo: trackingNumberText.leadingAnchor, constant: -10),
            copyButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
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
