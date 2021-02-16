//
//  GetFoodCategoriesRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol GetFoodCategoriesRequestProtocol {
    func response(foodCategory1List: [FoodCategory1]?, getFoodCategories status: String)
}


class GetFoodCategoriesRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetFoodCategoriesRequestProtocol?
    let apiUrl = API_URL + "/get/food/categories"
    
    
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
            delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(foodCategory1List: nil, getFoodCategories: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(FoodCategoriesRequestResult.self, from: data)
                let result = decoded.result
                
                let resFoodCategoryList = result
                var foodCategory1List: [FoodCategory1] = []
                
                for resFoodCategory in resFoodCategoryList {
                    let fc1Id = resFoodCategory.fc1_id
                    
                    var foodCategory2List: [FoodCategory2] = []
                    if let fc2s = resFoodCategory.fc2s {
                        let splittedfc2List = fc2s.split(separator: "|")
                        for splittedfc2 in splittedfc2List {
                            let splitted = splittedfc2.split(separator: ":")
                            guard let fc2Id = Int(splitted[0]) else { continue }
                            let fc2Name = String(splitted[1])
                            let foodCategory2 = FoodCategory2(id: fc2Id, fc1Id: fc1Id, name: fc2Name)
                            foodCategory2List.append(foodCategory2)
                        }
                    }
                    
                    let foodCategory1 = FoodCategory1(id: fc1Id, name: resFoodCategory.fc1_name, foodCategory2List: foodCategory2List)
                    foodCategory1List.append(foodCategory1)
                }
                
                self.delegate?.response(foodCategory1List: foodCategory1List, getFoodCategories: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(foodCategory1List: nil, getFoodCategories: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
