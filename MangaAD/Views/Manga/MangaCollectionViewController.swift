//
//  MangaCollectionViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 8/8/24.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import JGProgressHUD

private let reuseIdentifier = "Cell"

class MangaCollectionViewController: UICollectionViewController {
    
    var listManga: [Manga] = []
    var filteredManga: [Manga] = []
    var selectedCategory: String?
    
    //
    var isFetchingMore = false
    var currentPage = 0
    let itemsPerPage = 12 // số lượng item mỗi trang
    
    // JGProgressHUD
    private var progressHUD: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(selectedCategory ?? "")"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.barTintColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 40) / 3, height: (view.frame.height - 40) / 3)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        self.collectionView!.register(MangaCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        // Tải trang đầu tiên
        loadMoreData()
        //
        filteredManga = listManga
    }
    
    @objc func didTapBackButton() {
        let categoryVC = CategoryViewController()
        let naVC = UINavigationController(rootViewController: categoryVC)
        naVC.modalPresentationStyle = .fullScreen
        dismissWithCustomTransition(viewController: self)
    }
    
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
                   let author = dict["Author"] as? String,
                   let backdrop = dict["Backdrop"] as? String {
                    
                    // Lấy ID từ childSnapshot.key
                    let mangaID = childSnapshot.key
                    
                    let manga = Manga(ID: mangaID, Name: name, Image: image, Category: category, Description: description, Chapters: [], Author: author, Backdrop: backdrop, Rate: "")
                    newlistManga.append(manga)
                }
            }
            completion(newlistManga)
        })
    }

    func fetchChaptersForManga(mangaID: String, completion: @escaping ([Chapter]) -> Void) {
        let ref = Database.database().reference().child("Comic").child(mangaID).child("Chapters")
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

    
    func loadMoreData() {
        guard !isFetchingMore else { return }
        isFetchingMore = true
        showLoadingIndicator()
        
        fetchMangaFromFirebase(page: currentPage) { newManga in
            self.listManga.append(contentsOf: newManga)
            self.filterMangaByCategory()
            self.collectionView.reloadData()
            self.isFetchingMore = false
            self.currentPage += 1
            self.hideLoadingIndicator()
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
        var selectedManga = filteredManga[indexPath.row]
        
        // Gọi hàm fetchChaptersForManga để lấy chapters
        fetchChaptersForManga(mangaID: selectedManga.ID) { chapters in
            // Gán chapters vào thuộc tính Chapters của selectedManga
            selectedManga.Chapters = chapters
            // Tạo MangaDetailViewController
            let mangaDetailVC = MangaDetailViewController()
            mangaDetailVC.previousViewControllerType = "MangaCollectionViewController"
            mangaDetailVC.manga = selectedManga
            // Hiển thị MangaDetailViewController
            let naVC = UINavigationController(rootViewController: mangaDetailVC)
            naVC.modalPresentationStyle = .fullScreen
            self.presentWithCustomTransition(from: self, to: naVC)
        }
    }

    func updateSearchResults(for searchText: String) {
        if searchText.isEmpty {
            filteredManga = listManga
        } else {
            filteredManga = listManga.filter { $0.Name.lowercased().contains(searchText.lowercased()) }
        }
        
        collectionView.reloadData()
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
