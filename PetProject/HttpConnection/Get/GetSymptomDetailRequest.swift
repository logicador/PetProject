//
//  GetSymptomDetailRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/18.
//

import UIKit


protocol GetSymptomDetailRequestProtocol {
    func response(similarCnt: Int?, symptom: Symptom?, foodList: [Food]?, diseaseList: [Disease]?, getSymptomDetail status: String)
}


class GetSymptomDetailRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetSymptomDetailRequestProtocol?
    let apiUrl = API_URL + "/get/symptom/detail"
    
    
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
            delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(SymptomDetailRequestResult.self, from: data)
                let result = decoded.result
                
                let similarCnt = result.similarCnt
                let resSymptom = result.symptom
                let resFoodList = result.foodList
                let resDiseaseList = result.diseaseList
                
                let symptom = Symptom(id: resSymptom.s_id, bpId: resSymptom.s_bp_id, name: resSymptom.s_name)
                
                var foodList: [Food] = []
                for resFood in resFoodList {
                    let food = Food(id: resFood.f_id, fc1Id: resFood.f_fc1_id, fc2Id: resFood.f_fc2_id, name: resFood.f_name, descShort: resFood.f_desc_short, desc: resFood.f_desc, thumbnail: resFood.f_thumbnail, edible: resFood.f_edible, nutrientList: [])
                    foodList.append(food)
                }
                
                var diseaseList: [Disease] = []
                for resDisease in resDiseaseList {
                    let disease = Disease(id: resDisease.d_id, bpId: resDisease.d_bp_id, name: resDisease.d_name, reason: resDisease.d_reason, management: resDisease.d_management, operation: resDisease.d_operation, cnt: resDisease.cnt)
                    diseaseList.append(disease)
                }
                
                self.delegate?.response(similarCnt: similarCnt, symptom: symptom, foodList: foodList, diseaseList: diseaseList, getSymptomDetail: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(similarCnt: nil, symptom: nil, foodList: nil, diseaseList: nil, getSymptomDetail: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}

