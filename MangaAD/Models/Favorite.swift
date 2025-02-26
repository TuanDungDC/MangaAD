//
//  Favorite.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 2/8/24.
//

import Foundation
import UIKit

struct Favorite: Codable {
    var favorites: [String: [String: Manga]]
}

