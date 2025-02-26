//
//  PersonalInformationViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 2/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import JGProgressHUD

class PersonalInformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
        button.backgroundColor = UIColor(red: 0x44 / 255.0, green: 0x9E / 255.0, blue: 0xFF / 255.0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var progressHUD: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        nameUserTextField.delegate = self
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
        ref.observe(.value) { [weak self] snapshot in
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
    
    @objc func didTapSaveButton() {
        guard let uid = Auth.auth().currentUser?.uid,
              let newName = nameUserTextField.text, !newName.isEmpty else {
            return
        }
        
        showLoadingIndicator()
        
        let ref = Database.database().reference().child("Users").child(uid)
        ref.updateChildValues(["name": newName]) { error, _ in
            if let error = error {
                print("Error updating name: \(error)")
                self.hideLoadingIndicator()
                return
            }
            // Cập nhật tên khi người dùng đổi tên
            // Cập nhật userName trong bảng Ratings
            let ratingsRef = Database.database().reference().child("Ratings").child(uid)
            ratingsRef.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot {
                        let ratingId = childSnapshot.key
                        ratingsRef.child(ratingId).updateChildValues(["userName": newName])
                    }
                }
            }) { error in
                print("Error updating userName in Ratings table: \(error)")
            }
            
            self.hideLoadingIndicator()
            
            let ac = UIAlertController(title: "Thành công", message: "Tên người dùng đã được đổi thành công.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(ac, animated: true)
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
        
        showLoadingIndicator()
        
        let storageRef = Storage.storage().reference().child("user_avatar").child("\(uid).jpg")
        
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let self = self else { return }
            if let error = error {
                print("Error uploading avatar: \(error)")
                self.hideLoadingIndicator()
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    self.hideLoadingIndicator()
                    return
                }
                
                guard let downloadURL = url else {
                    self.hideLoadingIndicator()
                    return
                }
                
                let ref = Database.database().reference().child("Users").child(uid)
                ref.updateChildValues(["avatar": downloadURL.absoluteString]) { error, _ in
                    if let error = error {
                        print("Error updating avatar URL: \(error)")
                        self.hideLoadingIndicator()
                        return
                    }
                    print("Avatar URL updated successfully")
                }
                
                // Cập nhật avatar URL trong bảng Ratings
                let ratingsRef = Database.database().reference().child("Ratings").child(uid)
                ratingsRef.observe(.value, with: { snapshot in
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot {
                            let ratingId = childSnapshot.key
                            ratingsRef.child(ratingId).updateChildValues(["imgUser": downloadURL.absoluteString])
                        }
                    }
                    self.hideLoadingIndicator()
                }) { error in
                    print("Error updating avatar URL in Ratings table: \(error)")
                }
            }
        }
    }
    
    @objc func didTapLogOutButton() {
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
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        // Hiển thị cảnh báo
        present(alert, animated: true)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameUserTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func didTapBackButton() {
        let profileVC = ProfileViewController()
        let naVC = UINavigationController(rootViewController: profileVC)
        naVC.modalPresentationStyle = .fullScreen
        dismissWithCustomTransition(viewController: self)
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
        progressHUD?.textLabel.text = "Đang cập nhật..."
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
    
}
