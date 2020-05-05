//
//  Category.swift
//  Todo
//
//  Created by pop on 5/5/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
     @objc dynamic var name:String = ""
     let items = List<Item>()
}
