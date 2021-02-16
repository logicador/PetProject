//
//  FoodCategory1.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import Foundation


struct FoodCategory1: Codable {
    var id: Int
    var name: String
    var foodCategory2List: [FoodCategory2] = []
}
