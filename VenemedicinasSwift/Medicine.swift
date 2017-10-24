//
//  Medicine.swift
//  VenemedicinasSwift
//
//  Created by Alberto Tsang on 10/22/17.
//  Copyright © 2017 kicyiusoft. All rights reserved.
//

import UIKit

class Medicine: Codable {

    let Description: String
    let variant: [Variant]
    
    init(Description: String, variant: [Variant]) {
        self.Description = Description
        self.variant = variant
    }
    
}
