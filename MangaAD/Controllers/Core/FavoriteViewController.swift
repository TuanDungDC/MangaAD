//
//  FavoriteViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 29/7/24.
//

import UIKit
import FirebaseAuth
import SDWebImage

class FavoriteViewController: UIViewController {
    
    private var favMangaCollectionViewController: FavoriteMangaCollectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // setup MangaCollectionView
        setUpFavMangaCollectionView()
        // addConstraints
        addConstraints()
    }
    
    private func setupNavigationBar() {
        title = "Yêu thích"
        
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
