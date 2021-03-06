//
//  Food.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import Foundation


struct Food: Codable {
    var id: Int
    var fc1Id: Int
    var fc2Id: Int
    var name: String
    var descShort: String? = ""
    var desc: String? = ""
    var thumbnail: String? = ""
    var edible: String
    var nutrientList: [Nutrient] = []
}
