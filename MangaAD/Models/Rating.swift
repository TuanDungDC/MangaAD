//
//  Rating.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 2/8/24.
//

import Foundation

struct Rating: Codable {
    var imgUser: String
    var userName: String
    var mangaName: String
    var rateValue: String
    var comment: String
    var dateComment: String
    
    // Hàm để chuyển đổi từ model sang dictionary, sử dụng khi lưu dữ liệu lên Firebase
    func toDictionary() -> [String: Any] {
        return [
            "imgUser": imgUser,
            "userName": userName,
            "mangaName": mangaName,
            "rateValue": rateValue,
            "comment": comment,
            "dateComment": dateComment
        ]
    }
}

struct UserRatings: Codable {
    var uid: String
    var ratings: [Rating]
}

