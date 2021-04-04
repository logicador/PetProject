//
//  Question.swift
//  PetProject
//
//  Created by 서원영 on 2021/03/16.
//

import Foundation


struct Question: Codable {
    var id: Int
    var contents: String
    var status: String
    var answer: String? = ""
    var createdDate: String
    var answeredDate: String
}
