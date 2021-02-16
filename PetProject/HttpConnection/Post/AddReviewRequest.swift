//
//  AddReviewRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/15.
//

import UIKit


protocol AddReviewRequestProtocol {
    func response(review: Review?, addReview status: String)
}


class AddReviewRequest: HttpRequest {
    
    // MARK: Property
    var delegate: AddReviewRequestProtocol?
    var apiUrl = API_URL + "/add/review"
    
    
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
            delegate?.response(review: nil, addReview: "ERR_PARAM_DATA")
            return
        }
        
        guard let url = URL(string: apiUrl) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(review: nil, addReview: "ERR_URL")
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
                self.delegate?.response(review: nil, addReview: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(review: nil, addReview: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(review: nil, addReview: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(review: nil, addReview: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(review: nil, addReview: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(review: nil, addReview: status)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ReviewRequestResult.self, from: data)
                
                let result = decoded.result
                
                let resReview = result
                
                var imageList: [String] = []
                if let images = resReview.images {
                    for image in images.split(separator: "|") {
                        imageList.append(String(image))
                    }
                }
                
                let review = Review(id: resReview.pr_id, uId: resReview.pr_u_id, peId: resReview.pr_pe_id, pId: resReview.pr_p_id, title: resReview.pr_title, descAdv: resReview.pr_desc_adv, descDisadv: resReview.pr_desc_disadv, avgScore: resReview.pr_avg_score, palaScore: resReview.pr_pala_score, beneScore: resReview.pr_bene_score, costScore: resReview.pr_cost_score, side: resReview.pr_side, createdDate: resReview.pr_created_date, updatedDate: resReview.pr_updated_date, uNickName: resReview.u_nick_name, peBirth: resReview.pe_birth, peGender: resReview.pe_gender, bName: resReview.b_name, imageList: imageList)
                
                self.delegate?.response(review: review, addReview: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE") }
                self.delegate?.response(review: nil, addReview: "ERR_DATA_DECODE")
            }
            
        }})
        task.resume()
    }
}

