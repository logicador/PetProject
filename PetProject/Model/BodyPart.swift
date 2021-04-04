//
//  BodyPart.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import Foundation


struct BodyPart: Codable {
    var id: Int
    var name: String
    var diseaseList: [Disease] = []
    var symptomList: [Symptom] = []
}
