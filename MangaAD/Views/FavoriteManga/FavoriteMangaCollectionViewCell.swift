//
//  FavoriteMangaCollectionViewCell.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 11/8/24.
//

import UIKit
import SDWebImage

class FavoriteMangaCollectionViewCell: UICollectionViewCell {
    
    let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageManga: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameManga: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconRatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconRating1")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpViews() {
        addSubview(backdropView)
        addSubview(imageManga)
        addSubview(nameManga)
        addSubview(iconRatingImageView)
        addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            
            backdropView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            backdropView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backdropView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            backdropView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageManga.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            imageManga.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            imageManga.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            imageManga.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            nameManga.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            nameManga.leftAnchor.constraint(equalTo: imageManga.rightAnchor, constant: 10),
            nameManga.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            
            iconRatingImageView.topAnchor.constraint(equalTo: nameManga.bottomAnchor, constant: 20),
            iconRatingImageView.leftAnchor.constraint(equalTo: imageManga.rightAnchor, constant: 10),
            iconRatingImageView.widthAnchor.constraint(equalToConstant: 15),
            iconRatingImageView.heightAnchor.constraint(equalToConstant: 15),
            
            ratingLabel.topAnchor.constraint(equalTo: nameManga.bottomAnchor, constant: 20),
            ratingLabel.leftAnchor.constraint(equalTo: iconRatingImageView.rightAnchor, constant: 10),
            ratingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(with manga: Manga, rating: Double) {
        if let url = URL(string: manga.Image) {
            imageManga.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        nameManga.text = manga.Name
        ratingLabel.text = String(format: "%.2f", rating)
    }
}
