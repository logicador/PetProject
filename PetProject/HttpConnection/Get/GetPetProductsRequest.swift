//
//  GetSymptomDetailRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/18.
//

import UIKit


protocol GetPetProductsRequestProtocol {
    func response(productList: [Product]?, getPetProducts status: String)
}


class GetPetProductsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetPetProductsRequestProtocol?
    let apiUrl = API_URL + "/get/pet/products"
    
    
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
            delegate?.response(productList: nil, getPetProducts: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(productList: nil, getPetProducts: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(productList: nil, getPetProducts: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(productList: nil, getPetProducts: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(productList: nil, getPetProducts: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(productList: nil, getPetProducts: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(productList: nil, getPetProducts: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(productList: nil, getPetProducts: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(ProductsRequestResult.self, from: data)
                let resProductList = decoded.result
                
                var productList: [Product] = []
                for resProduct in resProductList {
                    let product = Product(id: resProduct.p_id, pcId: resProduct.p_pc_id, pbId: resProduct.p_pb_id, name: resProduct.p_name, price: resProduct.p_price, thumbnail: resProduct.p_thumbnail, origin: resProduct.p_origin, manufacturer: resProduct.p_manufacturer, packingVolume: resProduct.p_packing_volume, recommend: resProduct.p_recommend, totalScore: resProduct.p_total_score, createdDate: resProduct.p_created_date, updatedDate: resProduct.p_updated_date, pbName: resProduct.pb_name)
                    productList.append(product)
                }
                
                self.delegate?.response(productList: productList, getPetProducts: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(productList: nil, getPetProducts: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}

