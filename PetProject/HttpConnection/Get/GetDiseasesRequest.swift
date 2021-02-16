//
//  GetDiseasesRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol GetDiseasesRequestProtocol {
    func response(diseaseList: [Disease]?, getDiseases status: String)
}


class GetDiseasesRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetDiseasesRequestProtocol?
    let apiUrl = API_URL + "/get/diseases"
    
    
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
            delegate?.response(diseaseList: nil, getDiseases: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(diseaseList: nil, getDiseases: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(diseaseList: nil, getDiseases: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(diseaseList: nil, getDiseases: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(diseaseList: nil, getDiseases: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(diseaseList: nil, getDiseases: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(diseaseList: nil, getDiseases: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(diseaseList: nil, getDiseases: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(DiseasesRequestResult.self, from: data)
                let result = decoded.result
                
                let resDiseaseList = result
                var diseaseList: [Disease] = []
                for resDisease in resDiseaseList {
                    let disease = Disease(id: resDisease.d_id, bpId: resDisease.d_bp_id, name: resDisease.d_name, reason: resDisease.d_reason, management: resDisease.d_management, operation: resDisease.d_operation)
                    diseaseList.append(disease)
                }
                
                self.delegate?.response(diseaseList: diseaseList, getDiseases: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(diseaseList: nil, getDiseases: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
