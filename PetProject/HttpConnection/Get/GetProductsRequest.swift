//
//  GetProductsRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol GetProductsRequestProtocol {
    func response(productList: [Product]?, getProducts status: String)
}


class GetProductsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetProductsRequestProtocol?
    let apiUrl = API_URL + "/get/products"
    
    
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
            delegate?.response(productList: nil, getProducts: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(productList: nil, getProducts: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(productList: nil, getProducts: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(productList: nil, getProducts: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(productList: nil, getProducts: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(productList: nil, getProducts: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(productList: nil, getProducts: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(productList: nil, getProducts: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(ProductsRequestResult.self, from: data)
                let result = decoded.result
                
                let resProductList = result
                var productList: [Product] = []
                for resProduct in resProductList {
                    
                    var imageList: [String] = []
                    if let pImages = resProduct.pImages {
                        let splittedImageList = pImages.split(separator: "|")
                        for splittedImage in splittedImageList {
                            imageList.append(String(splittedImage))
                        }
                    }
                    
                    var detailImageList: [String] = []
                    if let pDetailImages = resProduct.pDetailImages {
                        let splittedDetailImageList = pDetailImages.split(separator: "|")
                        for splittedDetailImage in splittedDetailImageList {
                            detailImageList.append(String(splittedDetailImage))
                        }
                    }
                    
                    let reviewCnt = resProduct.reviewCnt ?? 0
                    let palaScore = resProduct.palaScore ?? 0
                    let beneScore = resProduct.beneScore ?? 0
                    let costScore = resProduct.costScore ?? 0
                    let avgScore = (palaScore + beneScore + costScore) / 3
                    let sideCnt = resProduct.sideCnt ?? 0
                    
                    let product = Product(id: resProduct.p_id, pcId: resProduct.p_pc_id, pbId: resProduct.p_pb_id, name: resProduct.p_name, price: resProduct.p_price, thumbnail: resProduct.p_thumbnail, origin: resProduct.p_origin, manufacturer: resProduct.p_manufacturer, packingVolume: resProduct.p_packing_volume, recommend: resProduct.p_recommend, totalScore: resProduct.p_total_score, createdDate: resProduct.p_created_date, updatedDate: resProduct.p_updated_date, pbName: resProduct.pb_name, fnProt: resProduct.fn_prot, fnFat: resProduct.fn_fat, fnFibe: resProduct.fn_fibe, fnAsh: resProduct.fn_ash, fnCalc: resProduct.fn_calc, fnPhos: resProduct.fn_phos, fnMois: resProduct.fn_mois, imageList: imageList, detailImageList: detailImageList, reviewCnt: reviewCnt, avgScore: avgScore, palaScore: palaScore, beneScore: beneScore, costScore: costScore, sideCnt: sideCnt)
                    productList.append(product)
                }
                
                self.delegate?.response(productList: productList, getProducts: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(productList: nil, getProducts: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}

