//
//  FavoriteViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 8/6/24.
//

import UIKit
import FirebaseAuth
import SDWebImage

class FavoriteViewController: UIViewController {
    
    private var favMangaCollectionViewController: FavoriteMangaCollectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup MangaCollectionView
        setUpFavMangaCollectionView()
        // addConstraints
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            favMangaCollectionViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            favMangaCollectionViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            favMangaCollectionViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            favMangaCollectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func setUpFavMangaCollectionView() {
        let layout = UICollectionViewFlowLayout()
        favMangaCollectionViewController = FavoriteMangaCollectionViewController(collectionViewLayout: layout)
        addChild(favMangaCollectionViewController)
        view.addSubview(favMangaCollectionViewController.view)
        favMangaCollectionViewController.didMove(toParent: self)
        favMangaCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
}
