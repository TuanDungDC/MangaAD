//
//  Category.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 8/6/24.
//

import Foundation
import UIKit

class Category: Codable {
    var tag: String
    
    init(tag: String) {
        self.tag = tag
    }
}
