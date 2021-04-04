//
//  GetFoodRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/17.
//

import UIKit


protocol GetFoodDetailRequestProtocol {
    func response(food: Food?, nutrientList: [Nutrient]?, diseaseList: [Disease]?, symptomList: [Symptom]?, getFoodDetail status: String)
}


class GetFoodDetailRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetFoodDetailRequestProtocol?
    let apiUrl = API_URL + "/get/food/detail"
    
    
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
            delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(FoodDetailRequestResult.self, from: data)
                let result = decoded.result
                
                let resFood = result.food
                let resNutrientList = result.nutrientList
                let resDiseaseList = result.diseaseList
                let resSymptomList = result.symptomList
                
                let food = Food(id: resFood.f_id, fc1Id: resFood.f_fc1_id, fc2Id: resFood.f_fc2_id, name: resFood.f_name, descShort: resFood.f_desc_short, desc: resFood.f_desc, thumbnail: resFood.f_thumbnail, edible: resFood.f_edible, nutrientList: [])
                
                var nutrientList: [Nutrient] = []
                for resNutrient in resNutrientList {
                    let nutrient = Nutrient(id: resNutrient.n_id, name: resNutrient.n_name, descShort: resNutrient.n_desc_short, desc: resNutrient.n_desc, descOver: resNutrient.n_desc_over)
                    nutrientList.append(nutrient)
                }
                
                var diseaseList: [Disease] = []
                for resDisease in resDiseaseList {
                    let disease = Disease(id: resDisease.d_id, bpId: resDisease.d_bp_id, name: resDisease.d_name, reason: resDisease.d_reason, management: resDisease.d_management, operation: resDisease.d_operation, cnt: resDisease.cnt)
                    diseaseList.append(disease)
                }
                
                var symptomList: [Symptom] = []
                for resSymptom in resSymptomList {
                    let symptom = Symptom(id: resSymptom.s_id, bpId: resSymptom.s_bp_id, name: resSymptom.s_name)
                    symptomList.append(symptom)
                }
                
                self.delegate?.response(food: food, nutrientList: nutrientList, diseaseList: diseaseList, symptomList: symptomList, getFoodDetail: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(food: nil, nutrientList: nil, diseaseList: nil, symptomList: nil, getFoodDetail: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
