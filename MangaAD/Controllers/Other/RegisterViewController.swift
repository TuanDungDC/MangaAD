//
//  RegisterViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 1/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "TẠO TÀI KHOẢN MỚI"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
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
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tên của tôi"
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
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mật khẩu"
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
        
        // Tạo button hình con mắt
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal) // Icon mắt mở
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected) // Icon mắt đóng
        eyeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        
        // Tạo một UIView để chứa eyeButton và đặt lề phải
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        rightView.addSubview(eyeButton)
        rightView.frame = CGRect(x: textField.frame.width, y: 0, width: 50, height: 40)
        
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let confirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Xác nhận mật khẩu"
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
        
        // Tạo button hình con mắt
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal) // Icon mắt mở
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected) // Icon mắt đóng
        eyeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        eyeButton.addTarget(self, action: #selector(toggleConfirmPasswordView), for: .touchUpInside)
        
        // Tạo rightView
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        rightView.addSubview(eyeButton)
        rightView.frame = CGRect(x: textField.frame.width, y: 0, width: 50, height: 40)
        
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đăng ký", for: .normal)
        button.backgroundColor = UIColor(red: 0x44 / 255.0, green: 0x9E / 255.0, blue: 0xFF / 255.0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
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
        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        // Thêm gesture recognizer để ẩn bàn phím khi nhấn ra ngoài
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        //
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackLoginButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        //
        colorPlaceholder()
    }
    
    func addSubView() {
        view.addSubview(signUpLabel)
        view.addSubview(emailTextField)
        view.addSubview(nameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmTextField)
        view.addSubview(signUpButton)
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            // signup label
            signUpLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.07),
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            //            signUpLabel.heightAnchor.constraint(equalToConstant: 70),
            // email
            emailTextField.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: view.bounds.height * 0.07),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            emailTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // password
            nameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: view.bounds.height * 0.0235),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            nameTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // pass
            passwordTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: view.bounds.height * 0.0235),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            passwordTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // confirm pass
            confirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: view.bounds.height * 0.0235),
            confirmTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            confirmTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            confirmTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // sign up button
            signUpButton.topAnchor.constraint(equalTo: confirmTextField.bottomAnchor, constant: view.bounds.height * 0.07),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.155),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.155),
            signUpButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
        ])
    }
    
    @objc func togglePasswordView(_ sender: UIButton) {
        sender.isSelected.toggle() // Đảo trạng thái của button
        passwordTextField.isSecureTextEntry.toggle() // Đảo trạng thái hiển thị mật khẩu
    }
    
    @objc func toggleConfirmPasswordView(_ sender: UIButton) {
        sender.isSelected.toggle() // Đảo trạng thái của button
        confirmTextField.isSecureTextEntry.toggle() // Đảo trạng thái hiển thị mật khẩu
    }
    
    func colorPlaceholder() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Tên của tôi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        confirmTextField.attributedPlaceholder = NSAttributedString(string: "Xác nhận mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.layer.borderColor = UIColor.blue.cgColor
        } else if textField == nameTextField{
            textField.layer.borderColor = UIColor.blue.cgColor
        } else if textField == passwordTextField {
            textField.layer.borderColor = UIColor.blue.cgColor
        } else {
            textField.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.layer.borderColor = UIColor.white.cgColor
        } else if textField == nameTextField{
            textField.layer.borderColor = UIColor.white.cgColor
        } else if textField == passwordTextField {
            textField.layer.borderColor = UIColor.white.cgColor
        } else {
            textField.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @objc func didTapBackLoginButton() {
        let loginVc = LoginViewController()
        let naVC = UINavigationController(rootViewController: loginVc)
        naVC.modalPresentationStyle = .fullScreen
        present(naVC, animated: true)
    }
    
    // Thêm phương thức này để ẩn bàn phím
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Triển khai phương thức textFieldShouldReturn để di chuyển đến trường nhập tiếp theo
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            nameTextField.becomeFirstResponder()
        } else if textField == nameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmTextField.becomeFirstResponder()
        } else if textField == confirmTextField {
            textField.resignFirstResponder() // Ẩn bàn phím khi đến trường cuối cùng
        }
        return true
    }
    
    // Sự kiện đăng ký tài khoản
    
    @objc func didTapSignUpButton() {
        
        if emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true || confirmTextField.text?.isEmpty ?? true {
            let ac = UIAlertController(title: "Thông báo", message: "Thông tin không được để trống. Vui lòng kiểm tra lại.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        } else if passwordTextField.text != confirmTextField.text {
            let ac = UIAlertController(title: "Thông báo", message: "Mật khẩu xác nhận không chính xác.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        } else {
            guard let email = emailTextField.text, !email.isEmpty,
                  let name = nameTextField.text, !name.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                
                if let error = error as NSError?, error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    let ac = UIAlertController(title: "Lỗi", message: "Email đã được sử dụng. Vui lòng sử dụng email khác.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(ac, animated: true)
                } else if let user = authResult?.user {
                    // Tạo một instance mới của model User
                    let newUser = User(uid: user.uid, name: name, avatar: "https://i.pinimg.com/736x/bc/43/98/bc439871417621836a0eeea768d60944.jpg", email: email, password: password)
                    // Lưu dữ liệu vào bảng `Users` với key là uid của người dùng
                    Database.database().reference().child("Users").child(user.uid).setValue(newUser.toDictionary()) { error, _ in
                        if let error = error {
                            let ac = UIAlertController(title: "Lỗi", message: error.localizedDescription, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            strongSelf.present(ac, animated: true)
                        } else {
                            // Thông báo hoặc xử lý sau khi lưu dữ liệu thành công
                            let ac = UIAlertController(title: "Thành công", message: "Tài khoản đã được tạo thành công.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            strongSelf.present(ac, animated: true)
                            // Xóa trường nhập liệu sau khi tạo tài khoản thành công.
                            strongSelf.emailTextField.text = ""
                            strongSelf.passwordTextField.text = ""
                            strongSelf.confirmTextField.text = ""
                        }
                    }
                }
            }
        }
    }
    
}
