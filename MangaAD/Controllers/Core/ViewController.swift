//
//  ViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 29/7/24.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ViewController: UIViewController, UISearchResultsUpdating {

    private var mangaCollectionViewController: MangaCollectionViewController!
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // setup MangaCollectionView
        setUpMangaCollectionView()
        // setUpSearch
        setUpSearchController()
        // addConstraints
        addConstraints()
    }
    
    private func setupNavigationBar() {
        title = "Trang chủ"
        
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

    private func addConstraints() {
        NSLayoutConstraint.activate([
            mangaCollectionViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mangaCollectionViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            mangaCollectionViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            mangaCollectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func setUpMangaCollectionView() {
        let layout = UICollectionViewFlowLayout()
        mangaCollectionViewController = MangaCollectionViewController(collectionViewLayout: layout)
        addChild(mangaCollectionViewController)
        view.addSubview(mangaCollectionViewController.view)
        mangaCollectionViewController.didMove(toParent: self)
        mangaCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Manga"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.overrideUserInterfaceStyle = .dark
        searchController.searchBar.setValue("Huỷ", forKey: "cancelButtonText")
        
        // Thay đổi màu text trong searchTextField
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            
            // Tuỳ chỉnh placeholder color nếu cần
            let attributedPlaceholder = NSAttributedString(
                string: "Search Manga",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
            )
            searchTextField.attributedPlaceholder = attributedPlaceholder
            
            // Tuỳ chỉnh màu icon search và clear button nếu cần
            if let leftView = searchTextField.leftView as? UIImageView {
                leftView.tintColor = .white
            }
            searchTextField.tintColor = .white
        }
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        mangaCollectionViewController.updateSearchResults(for: searchText)
    }
    
}
