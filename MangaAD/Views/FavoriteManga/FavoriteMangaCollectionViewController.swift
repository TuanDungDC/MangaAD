//
//  FavoriteMangaCollectionViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 11/8/24.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import NotificationCenter
import JGProgressHUD

private let reuseIdentifier = "Cell"

class FavoriteMangaCollectionViewController: UICollectionViewController {
    
    var averageRatings: [String: Double] = [:]
    var listManga: [Manga] = []
    var manga: Manga?
    
    private var progressHUD: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width , height: view.frame.height / 5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        self.collectionView!.register(FavoriteMangaCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // fetch dữ liệu
        fetchFavoritesFromFirebase()
        fetchRatingsAndCalculateAverage()
    }
    
    func fetchFavoritesFromFirebase() {
        showLoadingIndicator()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference(withPath: "Favorite").child(userID)
        
        ref.observe(.value, with: { snapshot in
            var newFavoriteManga: [Manga] = []
            
            // Ensure the snapshot contains a dictionary
            guard let favoriteDict = snapshot.value as? [String: Any] else {
                print("Error: Snapshot value is not a dictionary")
                return
            }
            
            for (mangaName, mangaDetails) in favoriteDict {
                guard let mangaDict = mangaDetails as? [String: Any],
                      let author = mangaDict["Author"] as? String,
                      let backdrop = mangaDict["Backdrop"] as? String,
                      let category = mangaDict["Category"] as? String,
                      let description = mangaDict["Description"] as? String,
                      let image = mangaDict["Image"] as? String else {
                    print("Error: Missing or invalid data for manga \(mangaName)")
                    continue
                }
                
                let manga = Manga(ID: mangaName, Name: mangaName, Image: image, Category: category, Description: description, Chapters: [], Author: author, Backdrop: backdrop, Rate: "")
                newFavoriteManga.append(manga)
            }
            
            DispatchQueue.main.async {
                self.listManga = newFavoriteManga.sorted(by: { $0.Name < $1.Name })
                self.hideLoadingIndicator()
                self.collectionView.reloadData()
            }
        })
    }
    
    func fetchChaptersForManga(mangaID: String, completion: @escaping ([Chapter]) -> Void) {
        let ref = Database.database().reference().child("Favorite").child(Auth.auth().currentUser!.uid).child(mangaID).child("Chapters")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var chapters: [Chapter] = []
            if let chaptersArray = snapshot.value as? [[String: Any]] {
                for chapterDict in chaptersArray {
                    if let links = chapterDict["Links"] as? [String],
                       let chapterName = chapterDict["Name"] as? String {
                        let chapter = Chapter(Links: links, Name: chapterName)
                        chapters.append(chapter)
                    }
                }
            }
            completion(chapters)
        })
    }
    
    
    func fetchRatingsAndCalculateAverage() {
        let ratingsRef = Database.database().reference(withPath: "Ratings")
        
        // Lấy dữ liệu
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
                self.averageRatings = averageRatings
                self.collectionView.reloadData()
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listManga.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteMangaCollectionViewCell
        
        // Configure the cell
        
        let manga = listManga[indexPath.row]
        cell.configure(with: manga, rating: averageRatings[manga.Name] ?? 0.00)
        return cell
    }
    
    //    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        print("Item at \(indexPath.row) selected")
    //        let mangaDetailVC = MangaDetailViewController()
    //        mangaDetailVC.previousViewControllerType = "FavoriteMangaCollectionViewController"
    //        mangaDetailVC.manga = listManga[indexPath.row]
    //        let naVC = UINavigationController(rootViewController: mangaDetailVC)
    //        naVC.modalPresentationStyle = .fullScreen
    //        presentWithCustomTransition(from: self, to: naVC)
    //    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selectedManga = listManga[indexPath.row]
        
        // Gọi hàm fetchChaptersForManga để lấy chapters
        fetchChaptersForManga(mangaID: selectedManga.ID) { chapters in
            // Cập nhật chapters cho selectedManga
            selectedManga.Chapters = chapters
            // Tạo MangaDetailViewController
            let mangaDetailVC = MangaDetailViewController()
            mangaDetailVC.previousViewControllerType = "FavoriteMangaCollectionViewController"
            mangaDetailVC.manga = selectedManga
            
            let naVC = UINavigationController(rootViewController: mangaDetailVC)
            naVC.modalPresentationStyle = .fullScreen
            self.presentWithCustomTransition(from: self, to: naVC)
        }
    }
        
        
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
