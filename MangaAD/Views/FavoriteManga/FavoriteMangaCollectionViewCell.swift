//
//  FavoriteMangaCollectionViewCell.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 9/6/24.
//

import UIKit
import SDWebImage

class FavoriteMangaCollectionViewCell: UICollectionViewCell {
    
    let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        addSubview(backdropImageView)
        addSubview(imageManga)
        addSubview(nameManga)
        addSubview(iconRatingImageView)
        addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            
            backdropImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            backdropImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            backdropImageView.heightAnchor.constraint(equalToConstant: 120),
            backdropImageView.widthAnchor.constraint(equalToConstant: 200),
            
            imageManga.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -70),
            imageManga.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40),
            imageManga.heightAnchor.constraint(equalToConstant: 100),
            imageManga.widthAnchor.constraint(equalToConstant: 80),
            
            nameManga.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            nameManga.leftAnchor.constraint(equalTo: backdropImageView.rightAnchor, constant: 20),
            nameManga.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            iconRatingImageView.topAnchor.constraint(equalTo: nameManga.bottomAnchor, constant: 20),
            iconRatingImageView.leftAnchor.constraint(equalTo: backdropImageView.rightAnchor, constant: 20),
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
        if let url1 = URL(string: manga.Backdrop) {
            backdropImageView.sd_setImage(with: url1, placeholderImage: UIImage(named: "placeholder"))
        }
        nameManga.text = manga.Name
        ratingLabel.text = String(format: "%.2f", rating)
    }
}
