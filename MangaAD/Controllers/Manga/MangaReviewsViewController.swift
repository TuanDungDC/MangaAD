//
//  MangaReviewsViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 13/8/24.
//

import UIKit
import SDWebImage
import Cosmos
import FirebaseDatabase

class MangaReviewsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var onDismiss: (() -> Void)?
    var manga: Manga?
    var ratings: [Rating] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(MangaReviewCell.self, forCellWithReuseIdentifier: MangaReviewCell.identifier)
        cv.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        //
        setupConstraints()
        fetchRatings()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchRatings() {
        let ratingsRef = Database.database().reference(withPath: "Ratings")
        
        // Lấy dữ liệu
        ratingsRef.observe(.value, with: { snapshot in
            var mangaRatings: [String: [[String: Any]]] = [:] // Sửa lại thành dictionary với key là String và value là mảng của dictionary
            var newRatings: [Rating] = []
            
            // Duyệt qua tất cả các ratings
            for userChild in snapshot.children {
                if let userSnapshot = userChild as? DataSnapshot {
                    for ratingChild in userSnapshot.children {
                        if let ratingSnapshot = ratingChild as? DataSnapshot,
                           let dict = ratingSnapshot.value as? [String: Any],
                           let mangaName = dict["mangaName"] as? String,
                           let rateValueString = dict["rateValue"] as? String,
                           let userName = dict["userName"] as? String,
                           let comment = dict["comment"] as? String,
                           let imgUserUrl = dict["imgUser"] as? String,
                           let dateComment = dict["dateComment"] as? String {
                            
                            let rating = Rating(imgUser: imgUserUrl, userName: userName, mangaName: mangaName, rateValue: rateValueString, comment: comment, dateComment: dateComment)
                            newRatings.append(rating)
                            
                            // Thêm dict vào mảng của manga tương ứng trong mangaRatings
                            mangaRatings[mangaName, default: []].append(dict)
                        }
                    }
                }
            }
            
            // Lọc để chỉ giữ lại các đánh giá của manga hiện tại
            var filteredRatings = newRatings.filter { $0.mangaName == self.manga?.Name }
            
            filteredRatings = filteredRatings.sorted(by: {$0.dateComment > $1.dateComment} )
            
            // Cập nhật UI trên main thread
            DispatchQueue.main.async {
                self.ratings = filteredRatings
                self.collectionView.reloadData() // Đảm bảo dữ liệu mới được hiển thị
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    @objc func didTapBackButton() {
        let mangaDetailVC = MangaDetailViewController()
        let naVC = UINavigationController(rootViewController: mangaDetailVC)
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
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in your data source
        return ratings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MangaReviewCell.identifier, for: indexPath) as? MangaReviewCell else {
            fatalError("Unable to dequeue MangaReviewCell")
        }
        // Configure the cell with data
        let rating = ratings[indexPath.item]
        cell.configure(with: rating)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 180)
    }
}

class MangaReviewCell: UICollectionViewCell {
    static let identifier = "MangaReviewCell"
    
    private let imgUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .half
        view.settings.starMargin = 5 // Điều chỉnh khoảng cách giữa các ngôi sao
        view.settings.totalStars = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        contentView.addSubview(imgUserImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(commentTextView)
        contentView.addSubview(cosmosView)
        contentView.addSubview(dateCommentLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // imgUserImageView constraints
            imgUserImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imgUserImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            imgUserImageView.widthAnchor.constraint(equalToConstant: 30),
            imgUserImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // userNameLabel constraints
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            userNameLabel.leftAnchor.constraint(equalTo: imgUserImageView.rightAnchor, constant: 10),
            userNameLabel.rightAnchor.constraint(equalTo: cosmosView.leftAnchor, constant: 10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // cosmosView constraints
            cosmosView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            cosmosView.leftAnchor.constraint(equalTo: userNameLabel.rightAnchor, constant: 10),
            cosmosView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            cosmosView.widthAnchor.constraint(equalToConstant: 120),
            cosmosView.heightAnchor.constraint(equalToConstant: 30),
            
            // commentTextView constraints
            commentTextView.topAnchor.constraint(equalTo: imgUserImageView.bottomAnchor, constant: 10),
            commentTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            commentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            commentTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // dateCommentLabel constraints
            dateCommentLabel.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 10),
            dateCommentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dateCommentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateCommentLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with rating: Rating) {
        imgUserImageView.sd_setImage(with: URL(string: rating.imgUser), placeholderImage: UIImage(named: "placeholder"))
        userNameLabel.text = rating.userName
        commentTextView.text = rating.comment
        if let rateValue = Double(rating.rateValue) {
            cosmosView.rating = rateValue
        } else {
            
        }
        dateCommentLabel.text = rating.dateComment
    }
}

