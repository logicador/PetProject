//
//  HttpResponse.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import Foundation


struct IntRequestResult: Codable {
    var result: Int
}

struct UserRequestResult: Codable {
    var result: UserResultResponse
}

struct BreedsRequestResult: Codable {
    var result: [BreedResultResponse]
}

struct InoculationsRequestResult: Codable {
    var result: [InoculationResultResponse]
}

struct ProductsRequestResult: Codable {
    var result: [ProductResultResponse]
}

struct DiseasesRequestResult: Codable {
    var result: [DiseaseResultResponse]
}

struct FoodCategoriesRequestResult: Codable {
    var result: [FoodCategoryResultResponse]
}

struct PetRequestResult: Codable {
    var result: PetResultResponse
}

struct PetIngredientRequestResult: Codable {
    var result: PetIngredientResultResponse
}

struct ProductIngredientRequestResult: Codable {
    var result: ProductIngredientResultResponse
}

struct ProductReviewRequestResult: Codable {
    var result: ProductReviewResultResponse
}

struct ReviewRequestResult: Codable {
    var result: ReviewResultResponse
}

struct NoticesRequestResult: Codable {
    var result: [NoticeResultResponse]
}


struct UserResultResponse: Codable {
    var u_id: Int
    var u_type: String? = ""
    var u_social_id: String? = ""
    var u_nick_name: String? = ""
    var u_email: String? = ""
    var u_password: String? = ""
    var u_pe_id: Int? = nil
    var u_level: Int
    var u_last_logined_platform: String? = ""
    var u_is_logined: String? = ""
    var u_status: String? = ""
    var u_created_date: String? = ""
    var u_updated_date: String? = ""
    var u_connected_date: String? = ""
    var petCnt: Int = 0
}

struct BreedResultResponse: Codable {
    var b_id: Int
    var b_name: String
    var b_type: String
}

struct InoculationResultResponse: Codable {
    var in_id: Int
    var in_name: String
}

struct ProductResultResponse: Codable {
    var p_id: Int
    var p_pc_id: Int
    var p_pb_id: Int
    var p_name: String
    var p_price: Int
    var p_thumbnail: String
    var p_origin: String
    var p_manufacturer: String
    var p_packing_volume: String
    var p_recommend: String
    var p_total_score: Double
    var p_created_date: String
    var p_updated_date: String
    
    var pb_name: String
    
    var fn_prot: Double? = 0
    var fn_fat: Double? = 0
    var fn_fibe: Double? = 0
    var fn_ash: Double? = 0
    var fn_calc: Double? = 0
    var fn_phos: Double? = 0
    var fn_mois: Double? = 0
    
    var pImages: String? = ""
    var pDetailImages: String? = ""
    
    var reviewCnt: Int? = 0
    var palaScore: Double? = 0
    var beneScore: Double? = 0
    var costScore: Double? = 0
    var sideCnt: Int? = 0
}

struct DiseaseResultResponse: Codable {
    var d_id: Int
    var d_bp_id: Int
    var d_name: String
    var d_reason: String? = ""
    var d_management: String? = ""
    var d_operation: String
    var cnt: Int? = 0
}

struct FoodCategoryResultResponse: Codable {
    var fc1_id: Int
    var fc1_name: String
    var fc2s: String? = ""
}

struct PetResultResponse: Codable {
    var pe_id: Int
    var pe_u_id: Int
    var pe_b_id: Int
    var pe_name: String
    var pe_thumbnail: String? = ""
    var pe_birth: Int
    var pe_bcs: Int
    var pe_gender: String
    var pe_neuter: String
    var pe_inoculation: String
    var pe_inoculation_text: String? = ""
    var pe_serial: String
    var pe_serial_no: String? = ""
    var pe_weight: Double
    var pe_created_date: String
    var pe_updated_date: String
    
    var b_name: String
    var b_type: String
}

struct PetIngredientResultResponse: Codable {
    var warningFoodList: [FoodResultResponse]
    var warningNutrientList: [NutrientResultResponse]
    var goodFoodList: [FoodResultResponse]
    var goodNutrientList: [NutrientResultResponse]
    var similarGoodFoodList: [FoodResultResponse]
    var similarGoodNutrientList: [NutrientResultResponse]
    var similarCnt: Int
    var weakDiseaseList: [DiseaseResultResponse]
}

struct ProductIngredientResultResponse: Codable {
    var foodList: [FoodResultResponse]
    var nutrientList: [NutrientResultResponse]
}

struct FoodResultResponse: Codable {
    var f_id: Int
    var f_fc1_id: Int
    var f_fc2_id: Int
    var f_name: String
    var f_desc: String? = ""
    var mfns: String? = ""
}

struct NutrientResultResponse: Codable {
    var n_id: Int
    var n_name: String
    var n_desc_short: String? = ""
    var n_desc: String? = ""
    var n_desc_over: String? = ""
}

struct ProductReviewResultResponse: Codable {
    var productReviewList: [ReviewResultResponse]
    var similarTotalScore: Double
    var similarPalaScore: Double
    var similarBeneScore: Double
    var similarCostScore: Double
    var similarSidePer: Int
    var totalScore: Double
    var palaScore: Double
    var beneScore: Double
    var costScore: Double
    var sidePer: Int
}

struct ReviewResultResponse: Codable {
    var pr_id: Int
    var pr_u_id: Int
    var pr_pe_id: Int
    var pr_p_id: Int
    var pr_title: String? = ""
    var pr_desc_adv: String? = ""
    var pr_desc_disadv: String? = ""
    var pr_avg_score: Double
    var pr_pala_score: Double
    var pr_bene_score: Double
    var pr_cost_score: Double
    var pr_side: String
    var pr_created_date: String
    var pr_updated_date: String
    
    var u_nick_name: String
    var pe_birth: Int
    var pe_gender: String
    var b_name: String
    
    var images: String? = ""
}

struct NoticeResultResponse: Codable {
    var no_id: Int
    var no_title: String
    var no_contents: String
    var no_created_date: String
    var no_updated_date: String
}
