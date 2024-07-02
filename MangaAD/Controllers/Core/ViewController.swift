//
//  ViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 29/5/24.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ViewController: UIViewController, UISearchResultsUpdating {

    private var mangaCollectionViewController: MangaCollectionViewController!
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup MangaCollectionView
        setUpMangaCollectionView()
        // setUpSearch
        setUpSearchController()
        if let textField = self.searchController.searchBar.searchTextField as? UITextField {
            textField.textColor = .white
            
            if let placeholderLabel = textField.value(forKey: "placeholderLabel") as? UILabel {
                placeholderLabel.textColor = .lightGray
            }
            
            textField.defaultTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 18)
            ]
        }
        // addConstraints
        addConstraints()
        //
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        mangaCollectionViewController.updateSearchResults(for: searchText)
    }
    
}
