//
//  Category.swift
//  ToDoHo
//
//  Created by Asser on 7/30/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name = ""
    var items = List<Item>()
}
