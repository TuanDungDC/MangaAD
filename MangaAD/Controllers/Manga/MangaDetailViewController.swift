//
//  MangaDetailViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 13/8/24.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import Cosmos

class MangaDetailViewController: UIViewController {
    
    var previousViewControllerType: String?
    var manga: Manga?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let mangaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()
    
    private let nameAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let cateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let averageRatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconRating1")
        return imageView
    }()
    
    
    private let averageRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconChat"), for: .normal)
        button.addTarget(self, action: #selector(didTapChatComment), for: .touchUpInside)
        return button
    }()
    
    private let favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconFavorite0"), for: .normal)
        button.setImage(UIImage(named: "iconFavorite1"), for: .selected)
        button.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let rateButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconRating0"), for: .normal)
        button.setImage(UIImage(named: "iconRating1"), for: .selected)
        button.addTarget(self, action: #selector(RateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let readButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Đọc truyện", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        setupReadButton()
        setupViews()
        setupScrollView()
        fetchRatingsAndCalculateAverage()
        if let manga = manga {
            backdropImageView.sd_setImage(with: URL(string: manga.Backdrop), completed: nil)
            mangaImageView.sd_setImage(with: URL(string: manga.Image), completed: nil)
            nameAuthorLabel.text = manga.Author
            cateLabel.text = manga.Category
            nameLabel.text = manga.Name
            descriptionLabel.text = manga.Description
            
            // Kiểm tra xem manga có trong danh sách yêu thích không
            checkIfMangaIsFavorite(manga) { isFavorite in
                self.favButton.isSelected = isFavorite
            }
            checkIfMangaIsRate(manga) { isRate in
                self.rateButton.isSelected = isRate
            }
        }
    }
    
    private func setupReadButton() {
        view.addSubview(readButton)
        readButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            readButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.bounds.width * 0.0636),
            readButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.bounds.width * 0.0636),
            readButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.bounds.height * 0.0235),
            readButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07)
        ])
    }
    
    
    private func setupViews() {
        view.addSubview(backdropImageView)
        view.addSubview(mangaImageView)
        view.addSubview(nameAuthorLabel)
        view.addSubview(cateLabel)
        view.addSubview(averageRatingImageView)
        view.addSubview(averageRatingLabel)
        view.addSubview(commentButton)
        view.addSubview(favButton)
        view.addSubview(rateButton)
        view.addSubview(nameLabel)
        
        // Set translatesAutoresizingMaskIntoConstraints to false
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        mangaImageView.translatesAutoresizingMaskIntoConstraints = false
        nameAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        cateLabel.translatesAutoresizingMaskIntoConstraints = false
        averageRatingImageView.translatesAutoresizingMaskIntoConstraints = false
        averageRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.translatesAutoresizingMaskIntoConstraints = false
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // backdropImageView constraints
            backdropImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            // mangaImageView constraints
            mangaImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -view.bounds.height * 0.1175),
            mangaImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.0636),
            mangaImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            mangaImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            // nameAuthorLabel constraints
            nameAuthorLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: view.bounds.height * 0.0235),
            nameAuthorLabel.leftAnchor.constraint(equalTo: mangaImageView.rightAnchor, constant: view.bounds.width * 0.0636),
            nameAuthorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            
            // cateLabel constraints
            cateLabel.topAnchor.constraint(equalTo: nameAuthorLabel.bottomAnchor, constant: view.bounds.height * 0.0235),
            cateLabel.leftAnchor.constraint(equalTo: mangaImageView.rightAnchor, constant: view.bounds.width * 0.0636),
            cateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            
            // averageRatingImageView constraints
            averageRatingImageView.topAnchor.constraint(equalTo: cateLabel.bottomAnchor, constant: view.bounds.height * 0.01175),
            averageRatingImageView.leftAnchor.constraint(equalTo: mangaImageView.rightAnchor, constant: view.bounds.width * 0.0636),
            averageRatingImageView.widthAnchor.constraint(equalTo: averageRatingImageView.heightAnchor),
            averageRatingImageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.0176),
            
            // averageRatingLabel constraints
            averageRatingLabel.topAnchor.constraint(equalTo: cateLabel.bottomAnchor, constant: view.bounds.height * 0.01175),
            averageRatingLabel.leftAnchor.constraint(equalTo: averageRatingImageView.rightAnchor, constant: view.bounds.width * 0.01272),
            averageRatingLabel.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.0235 * 3),
            averageRatingLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.0235),
            
            // commentButton constraints
            commentButton.topAnchor.constraint(equalTo: cateLabel.bottomAnchor, constant: view.bounds.height * 0.01175),
            commentButton.leftAnchor.constraint(equalTo: averageRatingLabel.rightAnchor, constant: view.bounds.width * 0.0636),
            commentButton.widthAnchor.constraint(equalTo: commentButton.heightAnchor),
            commentButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.0235),
            
            // favButton constraints
            favButton.topAnchor.constraint(equalTo: mangaImageView.bottomAnchor, constant: view.bounds.height * 0.0235),
            favButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.0636),
            favButton.widthAnchor.constraint(equalTo: favButton.heightAnchor),
            favButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.035),
            
            // rateButton constraints
            rateButton.topAnchor.constraint(equalTo: mangaImageView.bottomAnchor, constant: view.bounds.height * 0.0235),
            rateButton.leftAnchor.constraint(equalTo: favButton.rightAnchor, constant: view.bounds.width * 0.0636),
            rateButton.widthAnchor.constraint(equalTo: rateButton.heightAnchor),
            rateButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.035),
            
            // nameLabel constraints
            nameLabel.topAnchor.constraint(equalTo: favButton.bottomAnchor, constant: view.bounds.height * 0.0235),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
        ])
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: view.bounds.height * 0.0235),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            scrollView.bottomAnchor.constraint(equalTo: readButton.topAnchor, constant: -view.bounds.height * 0.0235)
        ])
        
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            // Quan trọng: Ràng buộc bottomAnchor của descriptionLabel với bottomAnchor của scrollView
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // Đặt chiều rộng của descriptionLabel bằng với scrollView để đảm bảo nó cuộn theo chiều dọc
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    @objc private func readButtonTapped() {
        guard let manga = manga else { return }
        
        let chapterListVC = ChapterListViewController()
        chapterListVC.chapters = manga.Chapters // Truyền danh sách chapter vào ChapterListViewController
        
        let naVC = UINavigationController(rootViewController: chapterListVC)
        naVC.modalPresentationStyle = .fullScreen
        presentWithCustomTransition(from: self, to: naVC)
    }
    
    @objc func didTapBackButton() {
        if previousViewControllerType ==  "MangaCollectionViewController" {
            let viewVC = ViewController()
            let naVC = UINavigationController(rootViewController: viewVC)
            naVC.modalPresentationStyle = .fullScreen
            dismissWithCustomTransition(viewController: self)
        } else if previousViewControllerType ==  "FavoriteMangaCollectionViewController"{
            let favoriteVC = ViewController()
            let naVC = UINavigationController(rootViewController: favoriteVC)
            naVC.modalPresentationStyle = .fullScreen
            dismissWithCustomTransition(viewController: self)
        }
    }
    
    @objc func didTapChatComment() {
        let reviewsVC = MangaReviewsViewController()
        reviewsVC.manga = manga
        let naVC = UINavigationController(rootViewController: reviewsVC)
        naVC.modalPresentationStyle = .fullScreen
        presentWithCustomTransition(from: self, to: naVC)
    }
    
    @objc private func favButtonTapped() {
        guard let manga = manga else { return }
        
        favButton.isSelected.toggle()
        
        if favButton.isSelected {
            confirmAddToFavorites(manga)
        } else {
            confirmRemoveFromFavorites(manga)
        }
    }
    
    private func addMangaToFavorites(_ manga: Manga) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "Favorite").child(userID).child(manga.Name)
        
        let favoriteData: [String: Any] = [
            "Name": manga.Name,
            "Author": manga.Author,
            "Category": manga.Category,
            "Description": manga.Description,
            "Image": manga.Image,
            "Backdrop": manga.Backdrop,
            "Chapters": manga.Chapters.map { chapter in
                return [
                    "Name": chapter.Name,
                    "Links": chapter.Links
                ]
            }
        ]
        
        ref.setValue(favoriteData) { error, _ in
            if let error = error {
                print("Error adding to favorites: \(error.localizedDescription)")
            } else {
                print("Successfully added to favorites")
            }
        }
    }
    
    private func removeMangaFromFavorites(_ manga: Manga) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "Favorite").child(userID).child(manga.Name)
        
        ref.removeValue { error, _ in
            if let error = error {
                print("Error removing from favorites: \(error.localizedDescription)")
            } else {
                print("Successfully removed from favorites")
            }
        }
    }
    
    private func checkIfMangaIsFavorite(_ manga: Manga, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let ref = Database.database().reference(withPath: "Favorite").child(userID).child(manga.Name)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func checkIfMangaIsRate(_ manga: Manga, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let ref = Database.database().reference(withPath: "Ratings").child(userID)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let ratingData = childSnapshot.value as? [String: Any],
                   let mangaName = ratingData["mangaName"] as? String,
                   mangaName == manga.Name {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
    
    // Function to show an alert before adding a manga to favorites
    func confirmAddToFavorites(_ manga: Manga) {
        let alertController = UIAlertController(title: "Thêm vào mục yêu thích", message: "Bạn có muốn thêm \(manga.Name) vào danh sách yêu thích của mình không?", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Có", style: .default) { _ in
            self.addMangaToFavorites(manga)
        }
        
        let cancelAction = UIAlertAction(title: "Không", style: .cancel) { _ in
            // Đặt lại trạng thái của nút nếu người dùng chọn "Không"
            self.favButton.isSelected = false
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // Function to show an alert before removing a manga from favorites
    func confirmRemoveFromFavorites(_ manga: Manga) {
        let alertController = UIAlertController(title: "Xoá khỏi mục yêu thích", message: "Bạn có muốn xoá \(manga.Name) khỏi danh sách yêu thích của mình không?", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Có", style: .destructive) { _ in
            self.removeMangaFromFavorites(manga)
        }
        
        let cancelAction = UIAlertAction(title: "Không", style: .cancel) { _ in
            // Đặt lại trạng thái của nút nếu người dùng chọn "Không"
            self.favButton.isSelected = true
        }
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    
    //
    @objc func RateButtonTapped() {
        guard let manga = manga else { return }
        let formSheet = UIViewController()
        formSheet.view.backgroundColor = .white
        formSheet.modalPresentationStyle = .formSheet
        
        let ratingView = RatingView()
        // Truyền giá trị manga vào ratingView
        ratingView.manga = manga
        
        // Thiết lập closure onSubmit để cập nhật trạng thái của rateButton khi người dùng đã đánh giá
        ratingView.onSubmit = { [weak self] in
            DispatchQueue.main.async {
                self?.rateButton.isSelected = true
                self?.dismiss(animated: true)
            }
        }
        
        
        formSheet.view.addSubview(ratingView)
        
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: formSheet.view.topAnchor),
            ratingView.bottomAnchor.constraint(equalTo: formSheet.view.bottomAnchor),
            ratingView.leadingAnchor.constraint(equalTo: formSheet.view.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: formSheet.view.trailingAnchor)
        ])
        
        self.present(formSheet, animated: true, completion: nil)
    }
    
    func fetchRatingsAndCalculateAverage() {
        let ratingsRef = Database.database().reference(withPath: "Ratings")
        
        // Lấy dữ liệu sử dụng observe để lắng nghe mỗi lần dữ liệu thay đổi
        ratingsRef.observe(.value, with: { snapshot in
            var mangaRatings: [String: [Double]] = [:]
            
            // Duyệt qua tất cả các ratings
            for userChild in snapshot.children {
                if let userSnapshot = userChild as? DataSnapshot {
                    for ratingChild in userSnapshot.children {
                        if let ratingSnapshot = ratingChild as? DataSnapshot,
                           let dict = ratingSnapshot.value as? [String: Any],
                           let mangaName = dict["mangaName"] as? String,
                           let rateValueString = dict["rateValue"] as? String,
                           let rateValue = Double(rateValueString) {
                            
                            if mangaRatings[mangaName] != nil {
                                mangaRatings[mangaName]?.append(rateValue)
                            } else {
                                mangaRatings[mangaName] = [rateValue]
                            }
                        }
                    }
                }
            }
            
            
            // Tính toán trung bình của các rateValue cho từng manga
            var averageRatings: [String: Double] = [:]
            for (mangaName, rateValues) in mangaRatings {
                let averageRating: Double
                
                averageRating = rateValues.reduce(0, +) / Double(rateValues.count)
                
                averageRatings[mangaName] = averageRating
            }
            
            // Cập nhật UI trên main thread
            DispatchQueue.main.async {
                for (mangaName, averageRating) in averageRatings {
                    if self.manga?.Name == mangaName {
                        self.averageRatingLabel.text = String(format: "%.2f", averageRating)
                    }
                }
                
            }
        }) { error in
            print(error.localizedDescription)
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
    
}
