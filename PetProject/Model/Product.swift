//
//  Product.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import Foundation


struct Product: Codable {
    var id: Int
    var pcId: Int
    var pbId: Int
    var name: String
    var price: Int
    var thumbnail: String
    var origin: String
    var manufacturer: String
    var packingVolume: String
    var recommend: String
    var totalScore: Double
    var createdDate: String
    var updatedDate: String
    
    var pbName: String
    
    var fnProt: Double? = 0
    var fnFat: Double? = 0
    var fnFibe: Double? = 0
    var fnAsh: Double? = 0
    var fnCalc: Double? = 0
    var fnPhos: Double? = 0
    var fnMois: Double? = 0
    
    var imageList: [String] = []
    var detailImageList: [String] = []
    
    var reviewCnt: Int = 0
    var avgScore: Double = 0
    var palaScore: Double = 0
    var beneScore: Double = 0
    var costScore: Double = 0
    var sideCnt: Int = 0
}
