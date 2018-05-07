//
//  Category.swift
//  Todoey
//
//  Created by Panos Lee Sapounakis on 06/05/2018.
//  Copyright © 2018 Dev Lee Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    
}
