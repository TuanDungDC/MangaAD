//
//  MangaCollectionViewCell.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 8/8/24.
//

import UIKit
import SDWebImage

class MangaCollectionViewCell: UICollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpViews() {
        addSubview(imageManga)
        addSubview(nameManga)
        
        NSLayoutConstraint.activate([
            imageManga.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageManga.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageManga.heightAnchor.constraint(equalToConstant: self.frame.height - self.frame.height * 65/(self.frame.height)),
            imageManga.widthAnchor.constraint(equalToConstant: self.frame.width),
            
            nameManga.topAnchor.constraint(equalTo: imageManga.bottomAnchor, constant: self.frame.height * 5/(self.frame.height)),
            nameManga.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameManga.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameManga.heightAnchor.constraint(equalToConstant: self.frame.height * 60/(self.frame.height))
        ])
    }
    
    func configure(with manga: Manga) {
        if let url = URL(string: manga.Image) {
            imageManga.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        nameManga.text = manga.Name
    }
}

