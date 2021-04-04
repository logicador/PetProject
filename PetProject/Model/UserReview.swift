//
//  UserReview.swift
//  PetProject
//
//  Created by 서원영 on 2021/03/16.
//

import Foundation


struct UserReview: Codable {
    var id: Int
    var descAdv: String? = ""
    var descDisadv: String? = ""
    
    var pId: Int
    var pThumbnail: String
}
