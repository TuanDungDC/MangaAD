//
//  FavoriteMangaCollectionViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 9/6/24.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import NotificationCenter
private let reuseIdentifier = "Cell"

class FavoriteMangaCollectionViewController: UICollectionViewController {
    
    var averageRatings: [String: Double] = [:]
    var listManga: [Manga] = []
    var manga: Manga?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 40 , height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        self.collectionView!.register(FavoriteMangaCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // Sử dụng viewWillAppear để tải dữ liệu (thường xuyên thay đổi) để cập nhật mỗi khi quay về view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoritesFromFirebase()
        fetchRatingsAndCalculateAverage()
    }
    
    func fetchFavoritesFromFirebase() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "Favorite").child(userID)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
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
                      let image = mangaDict["Image"] as? String,
                      let chaptersArray = mangaDict["Chapters"] as? [[String: Any]] else {
                    print("Error: Missing or invalid data for manga \(mangaName)")
                    continue
                }
                
                var chapters: [Chapter] = []
                for chapterDict in chaptersArray {
                    if let links = chapterDict["Links"] as? [String],
                       let chapterName = chapterDict["Name"] as? String {
                        let chapter = Chapter(Links: links, Name: chapterName)
                        chapters.append(chapter)
                    }
                }
                
                let manga = Manga(Name: mangaName, Image: image, Category: category, Description: description, Chapters: chapters, Author: author, Backdrop: backdrop, Rate: "")
                newFavoriteManga.append(manga)
            }
            
            DispatchQueue.main.async {
                self.listManga = newFavoriteManga.sorted(by: {$0.Name < $1.Name})
                self.collectionView.reloadData()
            }
        })
    }
    
    func fetchRatingsAndCalculateAverage() {
        let ratingsRef = Database.database().reference(withPath: "Ratings")
        
        // Lấy dữ liệu
        ratingsRef.observeSingleEvent(of: .value, with: { snapshot in
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item at \(indexPath.row) selected")
        let mangaDetailVC = MangaDetailViewController()
        mangaDetailVC.onDismiss = { [weak self] in
            self?.fetchFavoritesFromFirebase()
            self?.fetchRatingsAndCalculateAverage()
        }
        mangaDetailVC.manga = listManga[indexPath.row]
        let naVC = UINavigationController(rootViewController: mangaDetailVC)
        naVC.modalPresentationStyle = .fullScreen
        present(naVC, animated: true)
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
