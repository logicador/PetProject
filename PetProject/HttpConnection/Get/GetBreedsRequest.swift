//
//  GetBreedsRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


protocol GetBreedsRequestProtocol {
    func response(breedList: [Breed]?, getBreeds status: String)
}


class GetBreedsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetBreedsRequestProtocol?
    let apiUrl = API_URL + "/get/breeds"
    
    
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
            delegate?.response(breedList: nil, getBreeds: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(breedList: nil, getBreeds: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(breedList: nil, getBreeds: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(breedList: nil, getBreeds: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(breedList: nil, getBreeds: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(breedList: nil, getBreeds: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(breedList: nil, getBreeds: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(breedList: nil, getBreeds: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(BreedsRequestResult.self, from: data)
                let result = decoded.result
                
                let resBreedList = result
                var breedList: [Breed] = []
                for resBreed in resBreedList {
                    let breed = Breed(id: resBreed.b_id, name: resBreed.b_name, type: resBreed.b_type)
                    breedList.append(breed)
                }
                
                self.delegate?.response(breedList: breedList, getBreeds: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(breedList: nil, getBreeds: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
