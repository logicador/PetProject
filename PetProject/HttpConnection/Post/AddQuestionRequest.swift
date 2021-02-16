//
//  AddQuestionRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


protocol AddQuestionRequestProtocol {
    func response(addQuestion status: String)
}


class AddQuestionRequest: HttpRequest {
    
    // MARK: Property
    var delegate: AddQuestionRequestProtocol?
    var apiUrl = API_URL + "/add/question"
    
    
    // MARK: Fetch
    func fetch(vc: UIViewController, isShowAlert: Bool = true, paramDict: [String: String]) {
        print("[HTTP REQ]", apiUrl, paramDict)
        
        if !vc.isNetworkAvailable() {
            if isShowAlert { vc.showNetworkAlert() }
            return
        }
        
        let paramString = makeParamString(paramDict: paramDict)
        
        guard let paramData = paramString.data(using: .utf8) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_PARAM_DATA") }
            delegate?.response(addQuestion: "ERR_PARAM_DATA")
            return
        }
        
        guard let url = URL(string: apiUrl) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(addQuestion: "ERR_URL")
            return
        }
        
        let httpRequest = getPostRequest(url: url, paramData: paramData)
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForRequest = HTTP_TIMEOUT
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
            
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(addQuestion: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(addQuestion: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(addQuestion: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(addQuestion: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(addQuestion: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(addQuestion: status)
                return
            }
            
            self.delegate?.response(addQuestion: "OK")
            
        }})
        task.resume()
    }
}

