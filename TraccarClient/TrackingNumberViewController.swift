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
        
        // Set up UI elements
        setupUI()
    }
    
    func setupUI() {
        // Set up image view
        imageView.image = UIImage(named: "Background") // Replace with your image name
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Set up container view
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.8) // Slightly transparent
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Set up tracking number label
        trackingNumberLabel.text = "Tracking Number:"
        trackingNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberLabel)
        
        // Set up tracking number text
        trackingNumberText.text = "123456"
        trackingNumberText.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trackingNumberText)
        
        // Set up copy button
        copyButton.setTitle("Copy", for: .normal)
        copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(copyButton)
        
        // Set up record button
        recordButton.setTitle("Pause", for: .normal)
        recordButton.backgroundColor = .green
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)
        
        // Set up constraints
        setupConstraints()
    }
    
    @objc func copyButtonTapped() {
        // Copy the text to the clipboard
        UIPasteboard.general.string = trackingNumberText.text
    }
    
    @objc func recordButtonTapped() {
        if recordButton.backgroundColor == .green {
            recordButton.backgroundColor = .red
            recordButton.setTitle("Recording", for: .normal)
            // Add recording icon
            let recordingIcon = UIImage(systemName: "record.circle")
            recordButton.setImage(recordingIcon, for: .normal)
        } else {
            recordButton.backgroundColor = .green
            recordButton.setTitle("Pause", for: .normal)
            // Add pause icon
            let pauseIcon = UIImage(systemName: "pause.circle")
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
            trackingNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            trackingNumberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            trackingNumberLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        // Tracking number text constraints
        NSLayoutConstraint.activate([
            trackingNumberText.leadingAnchor.constraint(equalTo: trackingNumberLabel.trailingAnchor, constant: 10),
            trackingNumberText.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -10),
            trackingNumberText.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        // Copy button constraints
        NSLayoutConstraint.activate([
            copyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
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
