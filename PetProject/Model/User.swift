//
//  User.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import Foundation


struct User: Codable {
    var id: Int
    var type: String? = ""
    var socialId: String? = ""
    var nickName: String? = ""
    var email: String? = ""
    var password: String? = ""
    var peId: Int? = nil
    var level: Int
    var lastLoginedPlatform: String? = ""
    var isLogined: String? = ""
    var status: String? = ""
    var createdDate: String? = ""
    var updatedDate: String? = ""
    var connectedDate: String? = ""
    var petCnt: Int = 0
}
