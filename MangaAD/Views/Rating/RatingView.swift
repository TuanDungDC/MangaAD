//
//  RatingView.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 14/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Cosmos

class RatingView: UIView {
    
    var manga: Manga?
    var onSubmit: (() -> Void)?
    
    let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .half
        view.settings.starMargin = 5 // Điều chỉnh khoảng cách giữa các ngôi sao
        view.settings.totalStars = 5 // Số lượng ngôi sao
        
        // Sử dụng các biểu tượng ngôi sao tùy chỉnh
        view.settings.emptyImage = UIImage(named: "iconRating0")
        view.settings.filledImage = UIImage(named: "iconRating1")
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Đánh giá"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Vui lòng đánh giá trải nghiệm của bạn"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let rateTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.backgroundColor = UIColor(red: 0xAB / 255.0, green: 0xAD / 255.0, blue: 0xBD / 255.0, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textView.layer.cornerRadius = 8.0
        return textView
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Gửi", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor(red: 0x48 / 255.0, green: 0xCA / 255.0, blue: 0xE7 / 255.0, alpha: 1)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0x2C / 255.0, green: 0x4B / 255.0, blue: 0xA1 / 255.0, alpha: 1)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(cosmosView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(rateTextView)
        self.addSubview(submitButton)
        
        // Đặt vị trí và kích thước cho các thành phần
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        rateTextView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Đặt vị trí cho cosmosView
            cosmosView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cosmosView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            
            // Đặt vị trí cho titleLabel
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Đặt vị trí cho descriptionLabel
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            // Đặt vị trí cho rateTextView
            rateTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            rateTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            rateTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            rateTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Đặt vị trí cho submitButton
            submitButton.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func submitButtonTapped() {
        // Xử lý khi người dùng nhấn nút gửi
        print("Người dùng đã nhấn nút gửi")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let rateValue = cosmosView.rating
        let comment = rateTextView.text ?? ""
        
        // Tạo DateFormatter để định dạng ngày giờ
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateComment = dateFormatter.string(from: Date())
        
        // Lấy thông tin từ bảng Users
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Không thể lấy thông tin người dùng")
                return
            }
            let imgUser = userData["avatar"] as? String
            let userName = userData["name"] as? String
            
            // Tạo đối tượng Rating
            let rating = Rating(imgUser: imgUser ?? "", userName: userName ?? "", mangaName: self.manga?.Name ?? "", rateValue: String(rateValue), comment: comment, dateComment: dateComment)
            
            // Đẩy dữ liệu lên Firebase Realtime Database
            let ratingsRef = Database.database().reference().child("Ratings").child(uid)
            let newRatingRef = ratingsRef.childByAutoId()
            newRatingRef.setValue(rating.toDictionary()) { error, _ in
                if let error = error {
                    print("Lỗi khi đẩy dữ liệu lên Firebase: \(error.localizedDescription)")
                } else {
                    print("Đã đẩy dữ liệu thành công")
                }
                // Gọi closure để thông báo rằng người dùng đã nhấn nút submit
                self.onSubmit?()
            }
        }
    }
}

