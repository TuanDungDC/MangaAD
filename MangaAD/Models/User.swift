//
//  User.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 1/8/24.
//

import Foundation
import UIKit

struct User: Codable {
    var uid: String
    var name: String
    var avatar: String
    var email: String
    var password: String

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

