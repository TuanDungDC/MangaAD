//
//  LaunchScreenViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 28/7/24.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let logoAppIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoLogin"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let logoLaunchScreenimageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoLaunchScreen"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        setUpLogoAppIcon()
        setupImageView()
        animateImageView()
    }
    
    private func setUpLogoAppIcon() {
        logoAppIconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoAppIconImageView)
        NSLayoutConstraint.activate([
            logoAppIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoAppIconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoAppIconImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            logoAppIconImageView.heightAnchor.constraint(equalTo: logoAppIconImageView.widthAnchor)
        ])
    }
    
    private func setupImageView() {
        logoLaunchScreenimageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoLaunchScreenimageView)
        NSLayoutConstraint.activate([
            logoLaunchScreenimageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLaunchScreenimageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            logoLaunchScreenimageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            logoLaunchScreenimageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.07)
        ])
    }
    
    private func animateImageView() {
        logoLaunchScreenimageView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseOut], animations: {
            self.logoLaunchScreenimageView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

