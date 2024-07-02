//
//  MangaCollectionViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 2/6/24.
//

import UIKit
import SDWebImage
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class MangaCollectionViewController: UICollectionViewController {
    
    var listManga: [Manga] = []
    var filteredManga: [Manga] = []
    var selectedCategory: String?
    
    //
    var isFetchingMore = false
    var currentPage = 0
    let itemsPerPage = 12 // số lượng item mỗi trang
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 40) / 3 - 0.01, height: (view.frame.height - 40) / 3)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        self.collectionView!.register(MangaCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
//        fetchMangaFromFirebase()
        // Tải trang đầu tiên
        loadMoreData()
        //
        filteredManga = listManga
    }
    
//    func fetchMangaFromFirebase() {
//        let ref = Database.database().reference().child("Comic")
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            var newlistManga: [Manga] = []
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot,
//                   let dict = childSnapshot.value as? [String: Any],
//                   let name = dict["Name"] as? String,
//                   let image = dict["Image"] as? String,
//                   let category = dict["Category"] as? String,
//                   let description = dict["Description"] as? String,
//                   let chaptersArray = dict["Chapters"] as? [[String: Any]],
//                   let author = dict["Author"] as? String,
//                   let backdrop = dict["Backdrop"] as? String {
//                    
//                    // Tạo danh sách các Chapter
//                    var chapters: [Chapter] = []
//                    for chapterDict in chaptersArray {
//                        if let links = chapterDict["Links"] as? [String],
//                           let chapterName = chapterDict["Name"] as? String {
//                            let chapter = Chapter(Links: links, Name: chapterName)
//                            chapters.append(chapter)
//                        }
//                    }
//                    
//                    // Tạo một Manga mới với danh sách Chapter
//                    let manga = Manga(Name: name, Image: image, Category: category, Description: description, Chapters: chapters, Author: author, Backdrop: backdrop, Rate: "")
//                    newlistManga.append(manga)
//                }
//            }
//            DispatchQueue.main.async {
//                self.updateMangaList(newlistManga)
//            }
//        })
//    }
    
    func fetchMangaFromFirebase(page: Int, completion: @escaping ([Manga]) -> Void) {
        let ref = Database.database().reference().child("Comic")
        ref.queryOrderedByKey().queryStarting(atValue: "\(page * itemsPerPage)").queryLimited(toFirst: UInt(itemsPerPage)).observeSingleEvent(of: .value, with: { snapshot in
            var newlistManga: [Manga] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let name = dict["Name"] as? String,
                   let image = dict["Image"] as? String,
                   let category = dict["Category"] as? String,
                   let description = dict["Description"] as? String,
                   let chaptersArray = dict["Chapters"] as? [[String: Any]],
                   let author = dict["Author"] as? String,
                   let backdrop = dict["Backdrop"] as? String {
                    
                    var chapters: [Chapter] = []
                    for chapterDict in chaptersArray {
                        if let links = chapterDict["Links"] as? [String],
                           let chapterName = chapterDict["Name"] as? String {
                            let chapter = Chapter(Links: links, Name: chapterName)
                            chapters.append(chapter)
                        }
                    }
                    
                    let manga = Manga(Name: name, Image: image, Category: category, Description: description, Chapters: chapters, Author: author, Backdrop: backdrop, Rate: "")
                    newlistManga.append(manga)
                }
            }
            completion(newlistManga)
        })
    }
    
    func loadMoreData() {
        guard !isFetchingMore else { return }
        isFetchingMore = true
        
        fetchMangaFromFirebase(page: currentPage) { newManga in
            self.listManga.append(contentsOf: newManga)
            self.filterMangaByCategory()
            self.collectionView.reloadData()
            self.isFetchingMore = false
            self.currentPage += 1
        }
    }
    
    func updateMangaList(_ mangaList: [Manga]) {
        self.listManga = mangaList
        self.filterMangaByCategory()
        self.collectionView.reloadData()
    }
    
    func filterMangaByCategory() {
        guard let selectedCategory = selectedCategory else {
            filteredManga = listManga
            return
        }
        
        filteredManga = listManga.filter { manga in
            return manga.Category.split(separator: "/").contains { $0.trimmingCharacters(in: .whitespaces) == selectedCategory }
        }
    }
    
    // MARK: - Infinite Scrolling
        
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            loadMoreData()
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
        return filteredManga.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MangaCollectionViewCell
        
        // Configure the cell
        let manga = filteredManga[indexPath.item]
        cell.configure(with: manga)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mangaDetailVC = MangaDetailViewController()
//        mangaDetailVC.onDismiss = { [weak self] in
//            self?.fetchMangaFromFirebase()
//        }
        mangaDetailVC.manga = filteredManga[indexPath.row]
        let naVC = UINavigationController(rootViewController: mangaDetailVC)
        naVC.modalPresentationStyle = .fullScreen
        present(naVC, animated: true)
    }
    
    
    func updateSearchResults(for searchText: String) {
        if searchText.isEmpty {
            filteredManga = listManga
        } else {
            filteredManga = listManga.filter { $0.Name.lowercased().contains(searchText.lowercased()) }
        }
        
        collectionView.reloadData()
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
