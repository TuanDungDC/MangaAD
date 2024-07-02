//
//  LoginViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 1/6/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoLogin"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "CHÀO MỪNG ĐẾN VỚI THẾ GIỚI TRUYỆN TRANH!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
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
    
    let forgotButton: UIButton = {
        let button = UIButton()
        button.setTitle("Quên mật khẩu?", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đăng nhập", for: .normal)
        button.backgroundColor = UIColor(red: 0x15 / 255.0, green: 0x1D / 255.0, blue: 0x3B / 255.0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Tạo tài khoản mới?"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đăng ký", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginGoogleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "loginGoogle"), for: .normal)
        button.layer.cornerRadius = 1000
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginFacebookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "loginFacebook"), for: .normal)
        button.layer.cornerRadius = 1000
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        // addSubview
        addSubView()
        //
        addConstraints()
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        // set màu cho placeholder
        colorPlaceholder()
        //
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func addSubView(){
        view.addSubview(logoImageView)
        view.addSubview(textLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgotButton)
        view.addSubview(loginButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        view.addSubview(loginGoogleButton)
        view.addSubview(loginFacebookButton)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            // logoImageView
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.094),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            // textLabel
            textLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: view.bounds.height * 0.0235),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.38),
            // email
            emailTextField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: view.bounds.height * 0.047),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            emailTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // password
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: view.bounds.height * 0.0235),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            passwordTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // forgot Button
            forgotButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: view.bounds.height * 0.005875),
            forgotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            // login button
            loginButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: view.bounds.height * 0.0235),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.155),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.155),
            loginButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            //
            signUpLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: view.bounds.height * 0.01175),
            signUpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.255),
            signUpLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.0235),
            //
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: view.bounds.height * 0.01175),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.255),
            signUpButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.0235),
            //
            loginGoogleButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: view.bounds.height * 0.0235),
            loginGoogleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.305),
            loginGoogleButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.075),
            loginGoogleButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.075),
            //
            loginFacebookButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: view.bounds.height * 0.0235),
            loginFacebookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.305),
            loginFacebookButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.075),
            loginFacebookButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.075)
        ])
    }
    
    
    @objc func togglePasswordView(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.layer.borderColor = UIColor.blue.cgColor // Thay đổi màu viền khi textField được chọn
            // Di chuyển placeholder lên trên (bạn cần tạo một UILabel để làm placeholder động)
        } else {
            textField.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.layer.borderColor = UIColor.white.cgColor // Trả lại màu viền ban đầu khi textField không được chọn
            // Đặt lại vị trí của placeholder nếu cần
        } else {
            textField.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func colorPlaceholder() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    @objc func didTapLoginButton(_ sender: UIButton) {
        let originalColor = sender.backgroundColor // Lưu màu ban đầu của nút
        sender.backgroundColor = UIColor(red: 0x44 / 255.0, green: 0x9E / 255.0, blue: 0xFF / 255.0, alpha: 1)
        
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                
                if error != nil {
                    sender.backgroundColor = originalColor // Đặt lại màu của nút nếu có lỗi
                    let ac = UIAlertController(title: "Lỗi", message: "Thông tin tài khoản và mật khẩu không chính xác. Vui lòng kiểm tra lại!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(ac, animated: true)
                } else if authResult?.user != nil {
                    // Đăng nhập thành công, hiển thị thông báo và chuyển đến màn hình chính.
                    let ac = UIAlertController(title: "Thông báo", message: "Đăng nhập thành công", preferredStyle: .alert)
                    strongSelf.present(ac, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        ac.dismiss(animated: true) {
                            let vc = TabBarViewController()
                            let naVC = UINavigationController(rootViewController: vc)
                            naVC.modalPresentationStyle = .fullScreen
                            strongSelf.present(naVC, animated: true)
                        }
                    }
                    
                    strongSelf.emailTextField.text = ""
                    strongSelf.passwordTextField.text = ""
                }
            }
        } else {
            sender.backgroundColor = originalColor // Đặt lại màu của nút nếu thông tin nhập vào bị trống
            let ac = UIAlertController(title: "Thông báo", message: "Thông tin không được để trống. Vui lòng kiểm tra lại.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func didTapForgotPasswordButton() {
        let forgotVc = ForgotPasswordViewController()
        let naVC = UINavigationController(rootViewController: forgotVc)
        naVC.modalPresentationStyle = .fullScreen
        present(naVC, animated: true)
    }
    
    @objc func didTapSignUpButton() {
        let regisVc = RegisterViewController()
        let naVC = UINavigationController(rootViewController: regisVc)
        naVC.modalPresentationStyle = .fullScreen
        present(naVC, animated: true)
    }

    @objc func didTapLoginGoogle() {
    
    }


    @objc func didTapLoginFacebook() {
        
    }
    
}
