//
//  GetPetIngredientRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import UIKit


protocol GetPetIngredientRequestProtocol {
    func response(warningFoodList: [Food]?, warningNutrientList: [Nutrient]?, goodFoodList: [Food]?, goodNutrientList: [Nutrient]?, similarGoodFoodList: [Food]?, similarGoodNutrientList: [Nutrient]?, similarCnt: Int?, weakDiseaseList: [Disease]?, getPetIngredient status: String)
}


class GetPetIngredientRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetPetIngredientRequestProtocol?
    let apiUrl = API_URL + "/get/pet/ingredient"
    
    
    // MARK: Fetch
    func fetch(vc: UIViewController, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        let paramString = makeParamString(paramDict: paramDict)
        
        // For GET method
        let urlString = "\(apiUrl)?\(paramString)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL_ENCODE") }
            delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(PetIngredientRequestResult.self, from: data)
                
                let result = decoded.result
                
                let resWarningFoodList = result.warningFoodList
                let resWarningNutrientList = result.warningNutrientList
                let resGoodFoodList = result.goodFoodList
                let resGoodNutrientList = result.goodNutrientList
                let resSimilarGoodFoodList = result.similarGoodFoodList
                let resSimilarGoodNutrientList = result.similarGoodNutrientList
                let similarCnt = result.similarCnt
                let resWeakDiseaseList = result.weakDiseaseList
                
                var warningFoodList: [Food] = []
                var warningNutrientList: [Nutrient] = []
                var goodFoodList: [Food] = []
                var goodNutrientList: [Nutrient] = []
                var similarGoodFoodList: [Food] = []
                var similarGoodNutrientList: [Nutrient] = []
                var weakDiseaseList: [Disease] = []
                
                for resFood in resWarningFoodList {
                    let food = Food(id: resFood.f_id, fc1Id: resFood.f_fc1_id, fc2Id: resFood.f_fc2_id, name: resFood.f_name, desc: resFood.f_desc, nutrientList: [])
                    warningFoodList.append(food)
                }
                for resNutrient in resWarningNutrientList {
                    let nutrient = Nutrient(id: resNutrient.n_id, name: resNutrient.n_name, descShort: resNutrient.n_desc_short, desc: resNutrient.n_desc, descOver: resNutrient.n_desc_over)
                    warningNutrientList.append(nutrient)
                }
                
                for resFood in resGoodFoodList {
                    let food = Food(id: resFood.f_id, fc1Id: resFood.f_fc1_id, fc2Id: resFood.f_fc2_id, name: resFood.f_name, desc: resFood.f_desc, nutrientList: [])
                    goodFoodList.append(food)
                }
                for resNutrient in resGoodNutrientList {
                    let nutrient = Nutrient(id: resNutrient.n_id, name: resNutrient.n_name, descShort: resNutrient.n_desc_short, desc: resNutrient.n_desc, descOver: resNutrient.n_desc_over)
                    goodNutrientList.append(nutrient)
                }
                
                for resFood in resSimilarGoodFoodList {
                    let food = Food(id: resFood.f_id, fc1Id: resFood.f_fc1_id, fc2Id: resFood.f_fc2_id, name: resFood.f_name, desc: resFood.f_desc, nutrientList: [])
                    similarGoodFoodList.append(food)
                }
                for resNutrient in resSimilarGoodNutrientList {
                    let nutrient = Nutrient(id: resNutrient.n_id, name: resNutrient.n_name, descShort: resNutrient.n_desc_short, desc: resNutrient.n_desc, descOver: resNutrient.n_desc_over)
                    similarGoodNutrientList.append(nutrient)
                }
                
                for resWeakDisease in resWeakDiseaseList {
                    let disease = Disease(id: resWeakDisease.d_id, bpId: resWeakDisease.d_bp_id, name: resWeakDisease.d_name, reason: resWeakDisease.d_reason, management: resWeakDisease.d_management, operation: resWeakDisease.d_operation, cnt: resWeakDisease.cnt)
                    weakDiseaseList.append(disease)
                }
                
                self.delegate?.response(warningFoodList: warningFoodList, warningNutrientList: warningNutrientList, goodFoodList: goodFoodList, goodNutrientList: goodNutrientList, similarGoodFoodList: similarGoodFoodList, similarGoodNutrientList: similarGoodNutrientList, similarCnt: similarCnt, weakDiseaseList: weakDiseaseList, getPetIngredient: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(warningFoodList: nil, warningNutrientList: nil, goodFoodList: nil, goodNutrientList: nil, similarGoodFoodList: nil, similarGoodNutrientList: nil, similarCnt: nil, weakDiseaseList: nil, getPetIngredient: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
