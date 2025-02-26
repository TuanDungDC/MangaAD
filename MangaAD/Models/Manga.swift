//
//  Manga.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 1/8/24.
//

import Foundation
import UIKit

struct Manga: Codable {
    var ID: String
    var Name: String
    var Image: String
    var Category: String
    var Description: String
    var Chapters: [Chapter]
    var Author: String
    var Backdrop: String
    var Rate: String
}

