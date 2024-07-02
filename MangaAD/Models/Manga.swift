//
//  Manga.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 2/6/24.
//

import Foundation
import UIKit

class Manga: Codable {
    var Name: String
    var Image: String
    var Category: String
    var Description: String
    var Chapters: [Chapter]
    var Author: String
    var Backdrop: String
    var Rate: String
    
    
    init(Name: String, Image: String, Category: String, Description: String, Chapters: [Chapter], Author: String, Backdrop: String, Rate: String) {
        self.Name = Name
        self.Image = Image
        self.Category = Category
        self.Description = Description
        self.Chapters = Chapters
        self.Author = Author
        self.Backdrop = Backdrop
        self.Rate = Rate
    }
}
