//
//  ChapterDetailViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 13/8/24.
//

import UIKit
import SDWebImage
import JGProgressHUD

class ChapterDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var links: [String] = []
    var imageSizes: [String: CGSize] = [:]
    
    private var progressHUD: JGProgressHUD?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0 // Không có khoảng cách giữa các dòng
        layout.minimumInteritemSpacing = 0 // Không có khoảng cách giữa các cột
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        // ẩn thành navigationBar khi vuốt
        self.navigationController?.hidesBarsOnSwipe = true
        
        // Sự kiện nhấn vào màn hình để hiển thị lại navigationBar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBar))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func toggleNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        let shouldShow = navigationController.isNavigationBarHidden
        navigationController.setNavigationBarHidden(!shouldShow, animated: true)
    }

    @objc private func didTapBackButton() {
        let chapterListVC = ChapterListViewController()
        let naVC = UINavigationController(rootViewController: chapterListVC)
        naVC.modalPresentationStyle = .fullScreen
        dismissWithCustomTransition(viewController: self)
    }
    
    func dismissWithCustomTransition(viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromLeft
        
        viewController.view.window?.layer.add(transition, forKey: kCATransition)
        viewController.dismiss(animated: false, completion: nil)
    }
    
    // JGProgressHUD
    
    private func showLoadingIndicator() {
        if progressHUD == nil {
            setupProgressHUD()
        }
        
        view.isUserInteractionEnabled = false
        progressHUD?.show(in: view)
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.view.isUserInteractionEnabled = true
            self?.progressHUD?.dismiss()
        }
    }
    
    private func setupProgressHUD() {
        progressHUD = JGProgressHUD(style: .light)
        progressHUD?.textLabel.text = "Đang tải..."
        progressHUD?.textLabel.textColor = .white
        progressHUD?.detailTextLabel.text = "Vui lòng đợi"
        progressHUD?.detailTextLabel.textColor = .white
        progressHUD?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemBlue
        activityIndicator.startAnimating()
        
        // Tăng kích thước của activityIndicator
        let scaleFactor: CGFloat = 1.5
        activityIndicator.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        let indicatorView = JGProgressHUDIndicatorView(contentView: activityIndicator)
        progressHUD?.indicatorView = indicatorView
        
        // Sử dụng Auto Layout để đảm bảo indicator luôn ở giữa theo chiều X
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
        ])
        
        // Điều chỉnh kích thước của contentView để phù hợp với activityIndicator đã được scale
        let contentSize: CGFloat = 120 * scaleFactor
        progressHUD?.contentView.bounds.size = CGSize(width: contentSize, height: contentSize)
        
        progressHUD?.show(in: self.view)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
//        let imageUrl = links[indexPath.item]
//        cell.imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
//        return cell
//    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        let imageUrl = links[indexPath.item]
        
        cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: [], completed: { [weak self] (image, error, cacheType, url) in
            guard let self = self, let image = image else { return }
            
            // Lưu kích thước ảnh
            self.imageSizes[imageUrl] = image.size
            
            // Cập nhật lại kích thước cell
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Điều chỉnh chiều cao của cell theo kích thước của hình ảnh
//        let imageUrl = links[indexPath.item]
//        if let image = SDImageCache.shared.imageFromCache(forKey: imageUrl) {
//            let width = collectionView.frame.width
//            let height = width * (image.size.height / image.size.width) // Giữ tỷ lệ của hình ảnh
//            return CGSize(width: width, height: height)
//        } else {
//            return CGSize(width: collectionView.frame.width, height: 200) // Kích thước tạm thời khi hình ảnh đang load
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageUrl = links[indexPath.item]
        return calculateCellSize(for: imageUrl, in: collectionView)
    }
    
    func calculateCellSize(for imageUrl: String, in collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.width
        
        if let imageSize = imageSizes[imageUrl] {
            // Sử dụng kích thước ảnh đã lưu
            let height = width * (imageSize.height / imageSize.width)
            return CGSize(width: width, height: height)
        } else if let image = SDImageCache.shared.imageFromCache(forKey: imageUrl) {
            // Nếu ảnh có trong cache nhưng chưa lưu kích thước
            imageSizes[imageUrl] = image.size
            let height = width * (image.size.height / image.size.width)
            return CGSize(width: width, height: height)
        } else {
            // Kích thước mặc định khi ảnh đang tải
            return CGSize(width: width, height: 200)
        }
    }
    
}

class ImageCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
