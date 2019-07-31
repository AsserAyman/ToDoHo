//
//  Item.swift
//  ToDoHo
//
//  Created by Asser on 7/30/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
