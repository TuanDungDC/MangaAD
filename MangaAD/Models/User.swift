//
//  User.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 1/6/24.
//

import Foundation
import UIKit

class User: Codable {
    var uid: String
    var name: String
    var avatar: String
    var email: String
    var password: String

    init(uid: String, name: String, avatar: String, email: String, password: String) {
        self.uid = uid
        self.name = name
        self.avatar = avatar
        self.email = email
        self.password = password
    }
    
    // Hàm để chuyển đổi từ model sang dictionary, sử dụng khi lưu dữ liệu lên Firebase
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "avatar": avatar,
            "email": email,
            "password": password
        ]
    }
}
