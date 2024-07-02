//
//  Rating.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 13/6/24.
//

import Foundation

class Rating: Codable {
    var imgUser: String
    var userName: String
    var mangaName: String
    var rateValue: String
    var comment: String
    var dateComment: String
    
    init(imgUser: String, userName: String, mangaName: String, rateValue: String, comment: String, dateComment: String) {
        self.imgUser = imgUser
        self.userName = userName
        self.mangaName = mangaName
        self.rateValue = rateValue
        self.comment = comment
        self.dateComment = dateComment
    }
    
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

class UserRatings: Codable {
    var uid: String
    var ratings: [Rating]
    
    init(uid: String, ratings: [Rating]) {
        self.uid = uid
        self.ratings = ratings
    }
}

