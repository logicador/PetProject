//
//  GetInoculationsRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol GetInoculationsRequestProtocol {
    func response(inoculationList: [Inoculation]?, getInoculations status: String)
}


class GetInoculationsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetInoculationsRequestProtocol?
    let apiUrl = API_URL + "/get/inoculations"
    
    
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
            delegate?.response(inoculationList: nil, getInoculations: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(inoculationList: nil, getInoculations: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(inoculationList: nil, getInoculations: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(inoculationList: nil, getInoculations: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(inoculationList: nil, getInoculations: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(inoculationList: nil, getInoculations: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(inoculationList: nil, getInoculations: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(inoculationList: nil, getInoculations: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(InoculationsRequestResult.self, from: data)
                let result = decoded.result
                
                let resInoculationList = result
                var inoculationList: [Inoculation] = []
                for resInoculation in resInoculationList {
                    let inoculation = Inoculation(id: resInoculation.in_id, name: resInoculation.in_name)
                    inoculationList.append(inoculation)
                }
                
                self.delegate?.response(inoculationList: inoculationList, getInoculations: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(inoculationList: nil, getInoculations: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
