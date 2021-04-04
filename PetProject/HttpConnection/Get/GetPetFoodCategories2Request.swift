//
//  GetSymptomDetailRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/18.
//

import UIKit


protocol GetPetFoodCategories2RequestProtocol {
    func response(foodCategory2List: [FoodCategory2]?, getPetFoodCategories2 status: String)
}


class GetPetFoodCategories2Request: HttpRequest {
    
    // MARK: Property
    var delegate: GetPetFoodCategories2RequestProtocol?
    let apiUrl = API_URL + "/get/pet/food/categories2"
    
    
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
            delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(foodCategory2List: nil, getPetFoodCategories2: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(FoodCategories2RequestResult.self, from: data)
                let resFoodCategory2List = decoded.result
                
                var foodCategory2List: [FoodCategory2] = []
                for resFoodCategory2 in resFoodCategory2List {
                    let foodCategory2 = FoodCategory2(id: resFoodCategory2.fc2_id, fc1Id: resFoodCategory2.fc2_fc1_id, name: resFoodCategory2.fc2_name)
                    foodCategory2List.append(foodCategory2)
                }
                
                self.delegate?.response(foodCategory2List: foodCategory2List, getPetFoodCategories2: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(foodCategory2List: nil, getPetFoodCategories2: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}

