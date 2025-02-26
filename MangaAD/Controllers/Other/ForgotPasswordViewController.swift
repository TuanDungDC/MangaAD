//
//  ForgotPasswordViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 2/8/24.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    
    let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "QUÊN MẬT KHẨU"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
    
    let confirmForgotButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gửi", for: .normal)
        button.backgroundColor = UIColor(red: 0x44 / 255.0, green: 0x9E / 255.0, blue: 0xFF / 255.0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapConfirmForgotButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        //
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackLoginButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        // addSubView
        addSubView()
        // addConstraints
        addConstraints()
        //
        emailTextField.delegate = self
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        //
        colorPlaceholder()
    }
    
    func addSubView() {
        view.addSubview(forgotPasswordLabel)
        view.addSubview(emailTextField)
        view.addSubview(confirmForgotButton)
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            // signup label
            forgotPasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.07),
            forgotPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
//            forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 70),
            // email
            emailTextField.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.0636),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.0636),
            emailTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            // login button
            confirmForgotButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: view.bounds.height * 0.0235),
            confirmForgotButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.height * 0.07),
            confirmForgotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.height * 0.07),
            confirmForgotButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
        ])
    }
    
    func colorPlaceholder() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @objc func didTapBackLoginButton() {
        let loginVc = LoginViewController()
        let naVC = UINavigationController(rootViewController: loginVc)
        naVC.modalPresentationStyle = .fullScreen
        present(naVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func didTapConfirmForgotButton() {
        // Kiểm tra trường nhập liệu email có trống không
        guard let email = emailTextField.text, !email.isEmpty else {
            let ac = UIAlertController(title: "Thông báo", message: "Email không được để trống. Vui lòng kiểm tra lại.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
            return
        }
        
        // Gửi yêu cầu đặt lại mật khẩu
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error as NSError? {
                if error.code == AuthErrorCode.userNotFound.rawValue {
                    // Nếu email không tồn tại
                    let ac = UIAlertController(title: "Lỗi", message: "Email không tồn tại. Vui lòng kiểm tra lại.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(ac, animated: true)
                } else {
                    // Nếu có lỗi khác
                    let ac = UIAlertController(title: "Lỗi", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    strongSelf.present(ac, animated: true)
                }
            } else {
                // Nếu không có lỗi, thông báo kiểm tra email
                let ac = UIAlertController(title: "Thành công", message: "Một email đặt lại mật khẩu đã được gửi. Vui lòng kiểm tra hộp thư của bạn.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    // Trở về trang LoginViewController
                    let loginVc = LoginViewController()
                    let naVC = UINavigationController(rootViewController: loginVc)
                    naVC.modalPresentationStyle = .fullScreen
                    strongSelf.present(naVC, animated: true)
                }))
                strongSelf.present(ac, animated: true)
            }
        }
    }
}
