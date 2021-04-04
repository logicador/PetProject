//
//  GetBreedCharactersRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/04/04.
//

import UIKit


protocol GetBreedCharactersRequestProtocol {
    func response(breedCharacter: BreedCharacter?, getBreedCharacters status: String)
}


class GetBreedCharactersRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetBreedCharactersRequestProtocol?
    let apiUrl = API_URL + "/get/breed/characters"
    
    
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
            delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(breedCharacter: nil, getBreedCharacters: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(GetBreedCharacterRequestResponse.self, from: data)
                let breedCharacter = decoded.result
                
                self.delegate?.response(breedCharacter: breedCharacter, getBreedCharacters: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(breedCharacter: nil, getBreedCharacters: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}


struct GetBreedCharacterRequestResponse: Codable {
    var result: BreedCharacter
}
struct BreedCharacter: Codable {
    var bc_ada: Int
    var bc_aff: Int
    var bc_apa: Int
    var bc_bar: Int
    var bc_cat: Int
    var bc_kid: Int
    var bc_dog: Int
    var bc_exe: Int
    var bc_tri: Int
    var bc_hea: Int
    var bc_int: Int
    var bc_jok: Int
    var bc_hai: Int
    var bc_soc: Int
    var bc_str: Int
    var bc_dom: Int
    var bc_tra: Int
    var bc_pro: Int
}
