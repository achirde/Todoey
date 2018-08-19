//
//  Category.swift
//  Todoey
//
//  Created by Arkadipra De on 8/18/18.
//  Copyright © 2018 Achirangshu. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
