//
//  Review.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import Foundation


struct Review: Codable {
    var id: Int
    var uId: Int
    var peId: Int
    var pId: Int
    var title: String? = ""
    var descAdv: String? = ""
    var descDisadv: String? = ""
    var avgScore: Double
    var palaScore: Double
    var beneScore: Double
    var costScore: Double
    var side: String
    var createdDate: String
    var updatedDate: String
    
    var uNickName: String
    var peBirth: Int
    var peGender: String
    var bName: String
    
    var imageList: [String] = []
}
