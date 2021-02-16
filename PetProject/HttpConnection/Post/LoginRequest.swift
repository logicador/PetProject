//
//  LoginRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


protocol LoginRequestProtocol {
    func response(user: User?, login status: String)
}


class LoginRequest: HttpRequest {
    
    // MARK: Property
    var delegate: LoginRequestProtocol?
    var apiUrl = API_URL + "/login"
    
    
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
            delegate?.response(user: nil, login: "ERR_PARAM_DATA")
            return
        }
        
        guard let url = URL(string: apiUrl) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(user: nil, login: "ERR_URL")
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
                self.delegate?.response(user: nil, login: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(user: nil, login: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(user: nil, login: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(user: nil, login: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(user: nil, login: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(user: nil, login: status)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(UserRequestResult.self, from: data)
                let result = decoded.result
                
                let resUser = result
                let user = User(id: resUser.u_id, type: resUser.u_type, socialId: resUser.u_social_id, nickName: resUser.u_nick_name, email: resUser.u_email, password: resUser.u_password, peId: resUser.u_pe_id, level: resUser.u_level, lastLoginedPlatform: resUser.u_last_logined_platform, isLogined: resUser.u_is_logined, status: resUser.u_status, createdDate: resUser.u_created_date, updatedDate: resUser.u_updated_date, connectedDate: resUser.u_connected_date, petCnt: resUser.petCnt)
                
                self.delegate?.response(user: user, login: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE") }
                self.delegate?.response(user: nil, login: "ERR_DATA_DECODE")
            }
            
        }})
        task.resume()
    }
}
