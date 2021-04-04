//
//  GetSymptomsRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/17.
//

import UIKit


protocol GetSymptomsRequestProtocol {
    func response(symptomList: [Symptom]?, getSymptoms status: String)
}


class GetSymptomsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetSymptomsRequestProtocol?
    let apiUrl = API_URL + "/get/symptoms"
    
    
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
            delegate?.response(symptomList: nil, getSymptoms: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(symptomList: nil, getSymptoms: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(symptomList: nil, getSymptoms: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(symptomList: nil, getSymptoms: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(symptomList: nil, getSymptoms: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(symptomList: nil, getSymptoms: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(symptomList: nil, getSymptoms: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(symptomList: nil, getSymptoms: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(SymptomsRequestResult.self, from: data)
                let result = decoded.result
                
                let resSymptomList = result
                var symptomList: [Symptom] = []
                for resSymptom in resSymptomList {
                    let symptom = Symptom(id: resSymptom.s_id, bpId: resSymptom.s_bp_id, name: resSymptom.s_name)
                    symptomList.append(symptom)
                }
                
                self.delegate?.response(symptomList: symptomList, getSymptoms: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(symptomList: nil, getSymptoms: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
