//
//  GetPetRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/12.
//

import UIKit


protocol GetPetRequestProtocol {
    func response(pet: Pet?, getPet status: String)
}


class GetPetRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetPetRequestProtocol?
    let apiUrl = API_URL + "/get/pet"
    
    
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
            delegate?.response(pet: nil, getPet: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(pet: nil, getPet: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(pet: nil, getPet: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(pet: nil, getPet: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(pet: nil, getPet: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(pet: nil, getPet: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(pet: nil, getPet: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(pet: nil, getPet: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(PetRequestResult.self, from: data)
                
                let result = decoded.result
                
                let resPet = result
                
                let breed = Breed(id: resPet.pe_b_id, name: resPet.b_name, type: resPet.b_type)
                
                let monthAge = vc.getMonthAge(birth: resPet.pe_birth)
                
                let pet = Pet(id: resPet.pe_id, uId: resPet.pe_u_id, bId: resPet.pe_b_id, name: resPet.pe_name, thumbnail: resPet.pe_thumbnail, birth: resPet.pe_birth, bcs: resPet.pe_bcs, gender: resPet.pe_gender, neuter: resPet.pe_neuter, inoculation: resPet.pe_inoculation, inoculationText: resPet.pe_inoculation_text, serial: resPet.pe_serial, serialNo: resPet.pe_serial_no, weight: resPet.pe_weight, createdDate: resPet.pe_created_date, updatedDate: resPet.pe_updated_date, breed: breed, monthAge: monthAge)
                
                self.delegate?.response(pet: pet, getPet: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(pet: nil, getPet: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
