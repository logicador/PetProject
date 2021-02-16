//
//  Nutrient.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import Foundation


struct Nutrient: Codable {
    var id: Int
    var name: String
    var descShort: String? = ""
    var desc: String? = ""
    var descOver: String? = ""
}
