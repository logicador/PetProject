//
//  Disease.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import Foundation


struct Disease: Codable {
    var id: Int
    var bpId: Int
    var name: String
    var reason: String? = ""
    var management: String? = ""
    var operation: String
    var cnt: Int? = 0
}
