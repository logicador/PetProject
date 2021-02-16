//
//  Notice.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import Foundation


struct Notice: Codable {
    var id: Int
    var title: String
    var contents: String
    var createdDate: String
    var updatedDate: String
}
