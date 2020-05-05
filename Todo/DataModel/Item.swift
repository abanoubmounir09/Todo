//
//  Item.swift
//  Todo
//
//  Created by pop on 5/5/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object{
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
