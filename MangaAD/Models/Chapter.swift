//
//  Chapter.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 2/6/24.
//

import Foundation
import UIKit

class Chapter: Codable {
    var Links: [String]
    var Name: String
    
    init(Links: [String], Name: String) {
        self.Links = Links
        self.Name = Name
    }
}
