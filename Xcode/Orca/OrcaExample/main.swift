//
//  main.swift
//  OrcaExample
//
//  Created by Elliott Minns on 10/02/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import Orca

class Cat: Model {
    
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
}


let cat = Cat(name: "Tigger", age: 10)

for property in cat.properties {
    print(property)
}

for value in cat.values {
    print(value)
}