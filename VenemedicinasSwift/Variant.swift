//
//  Variant.swift
//  VenemedicinasSwift
//
//  Created by Alberto Tsang on 10/22/17.
//  Copyright © 2017 kicyiusoft. All rights reserved.
//

import UIKit

class Variant: Codable {

    let City: String
    let Name: String
    
    init(city: String, name: String) {
        self.City = city
        self.Name = name
    }
}
