//
//  SavePetRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/11.
//

import UIKit


protocol SavePetRequestProtocol {
    func response(pet: Pet?, savePet status: String)
}


class SavePetRequest: HttpRequest {
    
    // MARK: Property
    var delegate: SavePetRequestProtocol?
    var apiUrl = API_URL + "/save/pet"
    
    
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
            delegate?.response(pet: nil, savePet: "ERR_PARAM_DATA")
            return
        }
        
        guard let url = URL(string: apiUrl) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(pet: nil, savePet: "ERR_URL")
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
                self.delegate?.response(pet: nil, savePet: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(pet: nil, savePet: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(pet: nil, savePet: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(pet: nil, savePet: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(pet: nil, savePet: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(pet: nil, savePet: status)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(PetRequestResult.self, from: data)
                
                let result = decoded.result
                
                let resPet = result
                
                let breed = Breed(id: resPet.pe_b_id, name: resPet.b_name, type: resPet.b_type)
                
                let monthAge = vc.getMonthAge(birth: resPet.pe_birth)
                
                let pet = Pet(id: resPet.pe_id, uId: resPet.pe_u_id, bId: resPet.pe_b_id, name: resPet.pe_name, thumbnail: resPet.pe_thumbnail, birth: resPet.pe_birth, bcsStep: resPet.pe_bcs_step, bcs: resPet.pe_bcs, gender: resPet.pe_gender, neuter: resPet.pe_neuter, inoculation: resPet.pe_inoculation, inoculationText: resPet.pe_inoculation_text, serial: resPet.pe_serial, serialNo: resPet.pe_serial_no, weight: resPet.pe_weight, createdDate: resPet.pe_created_date, updatedDate: resPet.pe_updated_date, breed: breed, monthAge: monthAge)
                
                self.delegate?.response(pet: pet, savePet: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE") }
                self.delegate?.response(pet: nil, savePet: "ERR_DATA_DECODE")
            }
            
        }})
        task.resume()
    }
}
