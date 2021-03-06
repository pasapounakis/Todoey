//
//  Item.swift
//  Todoey
//
//  Created by Panos Lee Sapounakis on 06/05/2018.
//  Copyright © 2018 Dev Lee Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""

    @objc dynamic var done: Bool = false
    
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
