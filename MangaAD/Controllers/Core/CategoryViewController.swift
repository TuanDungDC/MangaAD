//
//  CategoryViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 29/7/24.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var categories: [Category] = []

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        setupNavigationBar()
        setupCollectionView()
        
        // Tải dữ liệu từ Firebase
        loadCategories()
    }
    
    private func setupNavigationBar() {
        title = "Thể loại"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        // Để đảm bảo status bar có text màu trắng
        navigationController?.navigationBar.barStyle = .black
        
        // LeftBarButton
        
        let imageView = UIImageView(image: UIImage(named: "LogoLaunchScreenA"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let imageBarButtonItem = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = imageBarButtonItem
    }
    
    private func setupCollectionView() {
        // Thiết lập giao diện
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        // Đăng ký cell và thiết lập dataSource, delegate
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func loadCategories() {
        let ref = Database.database().reference(withPath: "Category")
        ref.observe(.value) { snapshot in
            var newCategories: [Category] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let tag = value["tag"] as? String,
                   let imgTag = value["imgTag"] as? String {
                    let category = Category(tag: tag, imgTag: imgTag)
                    newCategories.append(category)
                }
            }
            self.categories = newCategories
            self.collectionView.reloadData()
        }
    }

    // Function to present view controller with custom transition
    func presentWithCustomTransition(from viewController: UIViewController, to targetViewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromRight

        // Add the transition to the view controller's view
        viewController.view.window?.layer.add(transition, forKey: kCATransition)

        // Present the view controller
        viewController.present(targetViewController, animated: false, completion: nil)
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
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item].tag
        
        let mangaCollectionVC = MangaCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        mangaCollectionVC.selectedCategory = selectedCategory
        let naVC = UINavigationController(rootViewController: mangaCollectionVC)
        naVC.modalPresentationStyle = .fullScreen

        presentWithCustomTransition(from: self, to: naVC)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        let height = view.frame.height / 6
        return CGSize(width: width, height: height)
    }
}

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let backgroundLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(backgroundLabelView)
        contentView.addSubview(categoryLabel)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLabelView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Background image constraints
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Background label view constraints
            backgroundLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundLabelView.heightAnchor.constraint(equalToConstant: 50), // Chiều cao của nền label
            
            // Category label constraints
            categoryLabel.centerXAnchor.constraint(equalTo: backgroundLabelView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: backgroundLabelView.centerYAnchor)
        ])
    }
    
    func configure(with category: Category) {
        categoryLabel.text = category.tag
        if let url = URL(string: category.imgTag) {
            backgroundImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
