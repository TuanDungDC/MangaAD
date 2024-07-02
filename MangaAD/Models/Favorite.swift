//
//  Favorite.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 9/6/24.
//

import Foundation
import UIKit

class Favorite: Codable {
    var favorites: [String: [String: Manga]]

    init(favorites: [String: [String: Manga]]) {
        self.favorites = favorites
    }
}
