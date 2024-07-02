//
//  PersonalInformationViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 10/6/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class PersonalInformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var onDismiss: (() -> Void)?
    
    let avatarUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20.0
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let changeAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapChangeAvatar), for: .touchUpInside)
        return button
    }()
    
    let nameUserLabel: UILabel = {
        let label = UILabel()
        label.text = "Tên của tôi"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameUserTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .white
        textField.textColor = .white
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailUserLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailUserTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .white
        textField.textColor = .gray
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0x15 / 255.0, green: 0x1D / 255.0, blue: 0x3B / 255.0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        addSubView()
        addConstraints()
        fetchData()
    }
    
    private func addSubView() {
        view.addSubview(avatarUserImageView)
        view.addSubview(changeAvatarButton)
        view.addSubview(nameUserLabel)
        view.addSubview(nameUserTextField)
        view.addSubview(emailUserLabel)
        view.addSubview(emailUserTextField)
        view.addSubview(saveButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            avatarUserImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.0235),
            avatarUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarUserImageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.2035),
            avatarUserImageView.heightAnchor.constraint(equalTo: avatarUserImageView.widthAnchor),
            
            changeAvatarButton.topAnchor.constraint(equalTo: avatarUserImageView.bottomAnchor, constant: view.bounds.height * 0.005875),
            changeAvatarButton.centerXAnchor.constraint(equalTo: avatarUserImageView.centerXAnchor),
            
            nameUserLabel.topAnchor.constraint(equalTo: changeAvatarButton.bottomAnchor, constant: view.bounds.height * 0.035),
            nameUserLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            
            nameUserTextField.topAnchor.constraint(equalTo: nameUserLabel.bottomAnchor, constant: view.bounds.height * 0.01175),
            nameUserTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            nameUserTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            nameUserTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            
            emailUserLabel.topAnchor.constraint(equalTo: nameUserTextField.bottomAnchor, constant: view.bounds.height * 0.035),
            emailUserLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            
            emailUserTextField.topAnchor.constraint(equalTo: emailUserLabel.bottomAnchor, constant: view.bounds.height * 0.01175),
            emailUserTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            emailUserTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            emailUserTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            
            saveButton.topAnchor.constraint(equalTo: emailUserTextField.bottomAnchor, constant: view.bounds.height * 0.07),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            saveButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
        ])
    }
    
    private func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? NSDictionary,
                  let name = value["name"] as? String,
                  let email = value["email"] as? String,
                  let avatarURLString = value["avatar"] as? String,
                  let avatarURL = URL(string: avatarURLString) else {
                return
            }
            
            DispatchQueue.main.async {
                self.nameUserTextField.text = name
                self.emailUserTextField.text = email
                self.avatarUserImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
    
    @objc func didTapChangeAvatar() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc func didTapSaveButton(_ sender: UIButton) {
        let originalColor = sender.backgroundColor // Lưu màu ban đầu của nút
        sender.backgroundColor = UIColor(red: 0x44 / 255.0, green: 0x9E / 255.0, blue: 0xFF / 255.0, alpha: 1)
        guard let uid = Auth.auth().currentUser?.uid,
              let newName = nameUserTextField.text, !newName.isEmpty else {
            return
        }
        
        let ref = Database.database().reference().child("Users").child(uid)
        ref.updateChildValues(["name": newName]) { error, _ in
            if let error = error {
                sender.backgroundColor = originalColor
                print("Error updating name: \(error)")
                return
            }
            let ac = UIAlertController(title: "Thành công", message: "Mật khẩu đã được đổi thành công.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(ac, animated: true)
            sender.backgroundColor = originalColor
            print("Name updated successfully")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        avatarUserImageView.image = selectedImage
        uploadAvatarImage(selectedImage)
    }
    
    func uploadAvatarImage(_ image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        let storageRef = Storage.storage().reference().child("user_avatar").child("\(uid).jpg")
        
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let self = self else { return }
            if let error = error {
                print("Error uploading avatar: \(error)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                
                guard let downloadURL = url else {
                    return
                }
                
                let ref = Database.database().reference().child("Users").child(uid)
                ref.updateChildValues(["avatar": downloadURL.absoluteString]) { error, _ in
                    if let error = error {
                        print("Error updating avatar URL: \(error)")
                        return
                    }
                    print("Avatar URL updated successfully")
                }
                
                // Cập nhật avatar URL trong bảng Ratings
                let ratingsRef = Database.database().reference().child("Ratings").child(uid)
                ratingsRef.observeSingleEvent(of: .value, with: { snapshot in
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot {
                            let ratingId = childSnapshot.key
                            ratingsRef.child(ratingId).updateChildValues(["imgUser": downloadURL.absoluteString])
                        }
                    }
                }) { error in
                    print("Error updating avatar URL in Ratings table: \(error)")
                }
            }
        }
    }
    
    @objc func didTapLogOutButton(_ sender: UIButton) {
        let originalColor = sender.backgroundColor // Lưu màu ban đầu của nút
        sender.backgroundColor = UIColor(red: 0x44 / 255.0, green: 0x9E / 255.0, blue: 0xFF / 255.0, alpha: 1)
        // Tạo một UIAlertController mới
        let alert = UIAlertController(title: "Đăng Xuất", message: "Bạn có chắc chắn muốn đăng xuất không?", preferredStyle: .alert)
        
        // Thêm hành động cho việc đăng xuất
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                // Chuyển đến màn hình đăng nhập hoặc welcome screen sau khi đăng xuất
                let loginVC = LoginViewController()
                let naVC = UINavigationController(rootViewController: loginVC)
                naVC.modalPresentationStyle = .fullScreen
                self.present(naVC, animated: true)
            } catch let signOutError as NSError {
                print("Lỗi: \(signOutError)")
            }
        }))
        
        // Thêm hành động cho việc hủy đăng xuất
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            sender.backgroundColor = originalColor
        }))
        
        // Hiển thị cảnh báo
        present(alert, animated: true)
    }
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true) {
            self.onDismiss?()
        }
    }
}
