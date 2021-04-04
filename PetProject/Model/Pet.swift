//
//  Pet.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import Foundation


struct Pet: Codable {
    var id: Int
    var uId: Int
    var bId: Int
    var name: String
    var thumbnail: String? = ""
    var birth: Int
    var bcsStep: Int
    var bcs: Int
    var gender: String
    var neuter: String
    var inoculation: String
    var inoculationText: String? = ""
    var serial: String
    var serialNo: String? = ""
    var weight: Double
    var createdDate: String
    var updatedDate: String
    
    var breed: Breed
    var monthAge: Int
}
