//
//  ProfileViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 29/7/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ProfileViewController: UIViewController {
    
    let avatarUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20.0
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let informationButton: UIButton = {
        let button = UIButton()
        button.setTitle("👤 Thông tin cá nhân", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0x15 / 255.0, green: 0x1D / 255.0, blue: 0x3B / 255.0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapPersonalInfButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔐 Đổi mật khẩu", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0x15 / 255.0, green: 0x1D / 255.0, blue: 0x3B / 255.0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapChangePasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đăng xuất", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0x15 / 255.0, green: 0x1D / 255.0, blue: 0x3B / 255.0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDataFromUserDefaults()
        // Do any additional setup after loading the view.
        addSubView()
        //
        addConstraints()
        //
        fetchData()
    }
    
    
    
    private func addSubView() {
        view.addSubview(avatarUserImageView)
        view.addSubview(nameUserLabel)
        view.addSubview(emailUserLabel)
        view.addSubview(informationButton)
        view.addSubview(changePasswordButton)
        view.addSubview(logOutButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            //
            avatarUserImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            avatarUserImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarUserImageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.255),
            avatarUserImageView.heightAnchor.constraint(equalTo: avatarUserImageView.widthAnchor),
            //
            nameUserLabel.topAnchor.constraint(equalTo: avatarUserImageView.bottomAnchor, constant: view.bounds.height * 0.035),
            nameUserLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.0636),
            nameUserLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width * 0.0636),
            //
            emailUserLabel.topAnchor.constraint(equalTo: nameUserLabel.bottomAnchor, constant: view.bounds.height * 0.01175),
            emailUserLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.0636),
            emailUserLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.bounds.width * 0.0636),
            //
            informationButton.topAnchor.constraint(equalTo: emailUserLabel.bottomAnchor, constant: view.bounds.height * 0.1175),
            informationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            informationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            informationButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            //
            changePasswordButton.topAnchor.constraint(equalTo: informationButton.bottomAnchor, constant: view.bounds.height * 0.0235),
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            changePasswordButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            //
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -view.bounds.height * 0.01175),
            logOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            logOutButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
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
            
            // Lưu dữ liệu vào UserDefaults
            UserDefaults.standard.set(name, forKey: "userName")
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(avatarURLString, forKey: "userAvatarURL")
            
            DispatchQueue.main.async {
                self.nameUserLabel.text = name
                self.emailUserLabel.text = email
                self.avatarUserImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
    
    private func loadUserDataFromUserDefaults() {
        if let name = UserDefaults.standard.string(forKey: "userName") {
            nameUserLabel.text = name
        }
        if let email = UserDefaults.standard.string(forKey: "userEmail") {
            emailUserLabel.text = email
        }
        if let avatarURLString = UserDefaults.standard.string(forKey: "userAvatarURL"),
           let avatarURL = URL(string: avatarURLString) {
            avatarUserImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    @objc func didTapLogOutButton() {
        // Tạo một UIAlertController mới
        let alert = UIAlertController(title: "Đăng Xuất", message: "Bạn có chắc chắn muốn đăng xuất không?", preferredStyle: .alert)
        
        // Thêm hành động cho việc đăng xuất
        alert.addAction(UIAlertAction(title: "Có", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                self.clearUserDefaults()
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
        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: nil))
        
        // Hiển thị cảnh báo
        present(alert, animated: true)
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userAvatarURL")
        UserDefaults.standard.synchronize()
    }
    
    // Chuyển đến trang Thông tin cá nhân
    @objc func didTapPersonalInfButton() {
        let perVC = PersonalInformationViewController()
        let naVC = UINavigationController(rootViewController: perVC)
        naVC.modalPresentationStyle = .fullScreen
        presentWithCustomTransition(from: self, to: naVC)
    }
    
    // Chuyển đến trang đổi mật khẩu
    @objc func didTapChangePasswordButton() {
        let changePasswordVC = ChangePasswordViewController()
        let naVC = UINavigationController(rootViewController: changePasswordVC)
        naVC.modalPresentationStyle = .fullScreen
        presentWithCustomTransition(from: self, to: naVC)
    }
    
    // Function to present view controller with custom transition
    func presentWithCustomTransition(from viewController: UIViewController, to targetViewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromRight

        // Add the transition to the view controller's view
        viewController.view.window?.layer.add(transition, forKey: kCATransition)

        // Present the view controller
        viewController.present(targetViewController, animated: false, completion: nil)
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
    
}
