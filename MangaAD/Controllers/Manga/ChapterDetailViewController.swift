//
//  ChapterDetailViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 8/6/24.
//

import UIKit
import SDWebImage

class ChapterDetailViewController: UIViewController {

    var links: [String] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        setupImages()
        // Ẩn thanh Navigation Bar khi vuốt
        self.navigationController?.hidesBarsOnSwipe = true
        // Hiển thị Navigation Bar khi tap vào màn hình
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBar))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func toggleNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        let shouldShow = navigationController.isNavigationBarHidden
        navigationController.setNavigationBarHidden(!shouldShow, animated: true)
    }
    
    private func setupImages() {
        var previousImageView: UIImageView?

        for link in links {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.sd_setImage(with: URL(string: link), completed: nil)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

            if let previous = previousImageView {
                imageView.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            } else {
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            }

            // Thêm ràng buộc chiều cao cho imageView dựa trên tỷ lệ khung hình của ảnh
            imageView.sd_setImage(with: URL(string: link)) { (image, error, cacheType, url) in
                if let image = image {
                    let aspectRatio = image.size.height / image.size.width
                    NSLayoutConstraint.activate([
                        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio)
                    ])
                }
            }

            previousImageView = imageView
        }

        if let lastImageView = previousImageView {
            lastImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }
}
