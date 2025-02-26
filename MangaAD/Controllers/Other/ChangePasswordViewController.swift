//
//  ChangePasswordViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 3/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    let changePasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "ĐỔI MẬT KHẨU"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mật khẩu hiện tại"
        textField.isSecureTextEntry = true
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
        
        // Tạo button hình con mắt
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal) // Icon mắt mở
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected) // Icon mắt đóng
        eyeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        eyeButton.addTarget(self, action: #selector(toggleCurrentPasswordView), for: .touchUpInside)
        
        // Tạo một UIView để chứa eyeButton và đặt lề phải
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        rightView.addSubview(eyeButton)
        rightView.frame = CGRect(x: textField.frame.width, y: 0, width: 50, height: 40)
        
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mật khẩu mới"
        textField.isSecureTextEntry = true
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
        
        // Tạo button hình con mắt
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal) // Icon mắt mở
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected) // Icon mắt đóng
        eyeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        eyeButton.addTarget(self, action: #selector(toggleNewPasswordView), for: .touchUpInside)
        
        // Tạo một UIView để chứa eyeButton và đặt lề phải
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        rightView.addSubview(eyeButton)
        rightView.frame = CGRect(x: textField.frame.width, y: 0, width: 50, height: 40)
        
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Xác nhận mật khẩu mới"
        textField.isSecureTextEntry = true
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
        
        // Tạo button hình con mắt
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal) // Icon mắt mở
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected) // Icon mắt đóng
        eyeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        eyeButton.addTarget(self, action: #selector(toggleConfirmPasswordView), for: .touchUpInside)
        
        // Tạo một UIView để chứa eyeButton và đặt lề phải
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        rightView.addSubview(eyeButton)
        rightView.frame = CGRect(x: textField.frame.width, y: 0, width: 50, height: 40)
        
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đổi mật khẩu", for: .normal)
        button.backgroundColor = UIColor(red: 0x44 / 255.0, green: 0x9E / 255.0, blue: 0xFF / 255.0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapChangePasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        // addSubView
        addSubView()
        // addConstraints
        addConstraints()
        // delegate
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        // Thêm gesture recognizer để ẩn bàn phím khi nhấn ra ngoài
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        //
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        //
        colorPlaceholder()
    }
    
    func addSubView() {
        view.addSubview(changePasswordLabel)
        view.addSubview(currentPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(changePasswordButton)
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            // change password label
            changePasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.07),
            changePasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePasswordLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
//            changePasswordLabel.heightAnchor.constraint(equalToConstant: 70),
            // current password
            currentPasswordTextField.topAnchor.constraint(equalTo: changePasswordLabel.bottomAnchor, constant: view.bounds.height * 0.094),
            currentPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            currentPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            currentPasswordTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // new password
            newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: view.bounds.height * 0.0235),
            newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // confirm new password
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: view.bounds.height * 0.0235),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // change password button
            changePasswordButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: view.bounds.height * 0.07),
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.155),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.155),
            changePasswordButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
        ])
    }
    
    @objc func didTapBackButton() {
        let profileVC = ProfileViewController()
        let naVC = UINavigationController(rootViewController: profileVC)
        naVC.modalPresentationStyle = .fullScreen
        dismissWithCustomTransition(viewController: self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func colorPlaceholder() {
        currentPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu hiện tại", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu mới", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Xác nhận mật khẩu mới", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @objc func toggleCurrentPasswordView(_ sender: UIButton) {
        sender.isSelected.toggle() // Đảo trạng thái của button
        currentPasswordTextField.isSecureTextEntry.toggle() // Đảo trạng thái hiển thị mật khẩu
    }
    
    @objc func toggleNewPasswordView(_ sender: UIButton) {
        sender.isSelected.toggle() // Đảo trạng thái của button
        newPasswordTextField.isSecureTextEntry.toggle() // Đảo trạng thái hiển thị mật khẩu
    }
    
    @objc func toggleConfirmPasswordView(_ sender: UIButton) {
        sender.isSelected.toggle() // Đảo trạng thái của button
        confirmPasswordTextField.isSecureTextEntry.toggle() // Đảo trạng thái hiển thị mật khẩu
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder() // Ẩn bàn phím khi đến trường cuối cùng
        }
        return true
    }
    
    @objc func didTapChangePasswordButton() {
        
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            let ac = UIAlertController(title: "Thông báo", message: "Thông tin không được để trống. Vui lòng kiểm tra lại.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        guard newPassword == confirmPassword else {
            let ac = UIAlertController(title: "Thông báo", message: "Mật khẩu xác nhận không chính xác.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        guard let user = Auth.auth().currentUser, let email = user.email else {
            let ac = UIAlertController(title: "Lỗi", message: "Không thể xác thực người dùng. Vui lòng đăng nhập lại.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { [weak self] result, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                let ac = UIAlertController(title: "Lỗi", message: "Mật khẩu hiện tại không đúng.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                strongSelf.present(ac, animated: true)
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    let ac = UIAlertController(title: "Lỗi", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(ac, animated: true)
                    return
                }
                
                let ref = Database.database().reference().child("Users").child(user.uid)
                ref.updateChildValues(["password": newPassword]) { error, _ in
                    if let error = error {
                        let ac = UIAlertController(title: "Lỗi", message: error.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        strongSelf.present(ac, animated: true)
                        return
                    }
                    
                    let ac = UIAlertController(title: "Thành công", message: "Mật khẩu đã được đổi thành công.", preferredStyle: .alert)
                    strongSelf.present(ac, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        ac.dismiss(animated: true) {
                            let loginVC = LoginViewController()
                            let naVC = UINavigationController(rootViewController: loginVC)
                            naVC.modalPresentationStyle = .fullScreen
                            strongSelf.present(naVC, animated: true)
                        }
                    }
                }
            }
        }
    }
}

