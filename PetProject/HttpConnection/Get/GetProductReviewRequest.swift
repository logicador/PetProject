//
//  GetProductReviewRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/13.
//

import UIKit


protocol GetProductReviewRequestProtocol {
    func response(reviewList: [Review]?, similarTotalScore: Double?, similarPalaScore: Double?, similarBeneScore: Double?, similarCostScore: Double?, similarSidePer: Int?, totalScore: Double?, palaScore: Double?, beneScore: Double?, costScore: Double?, sidePer: Int?, getProductReview status: String)
}


class GetProductReviewRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetProductReviewRequestProtocol?
    let apiUrl = API_URL + "/get/product/review"
    
    
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
            delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(ProductReviewRequestResult.self, from: data)
                
                let result = decoded.result
                
                let resProductReviewList = result.productReviewList
                
                var reviewList: [Review] = []
                for resReview in resProductReviewList {
                    var imageList: [String] = []
                    if let images = resReview.images {
                        for image in images.split(separator: "|") {
                            imageList.append(String(image))
                        }
                    }
                    
                    let review = Review(id: resReview.pr_id, uId: resReview.pr_u_id, peId: resReview.pr_pe_id, pId: resReview.pr_p_id, title: resReview.pr_title, descAdv: resReview.pr_desc_adv, descDisadv: resReview.pr_desc_disadv, avgScore: resReview.pr_avg_score, palaScore: resReview.pr_pala_score, beneScore: resReview.pr_bene_score, costScore: resReview.pr_cost_score, side: resReview.pr_side, createdDate: resReview.pr_created_date, updatedDate: resReview.pr_updated_date, uNickName: resReview.u_nick_name, peBirth: resReview.pe_birth, peGender: resReview.pe_gender, bName: resReview.b_name, imageList: imageList)
                    reviewList.append(review)
                }
                
                self.delegate?.response(reviewList: reviewList, similarTotalScore: result.similarTotalScore, similarPalaScore: result.similarPalaScore, similarBeneScore: result.similarBeneScore, similarCostScore: result.similarCostScore, similarSidePer: result.similarSidePer, totalScore: result.totalScore, palaScore: result.palaScore, beneScore: result.beneScore, costScore: result.costScore, sidePer: result.sidePer, getProductReview: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(reviewList: nil, similarTotalScore: nil, similarPalaScore: nil, similarBeneScore: nil, similarCostScore: nil, similarSidePer: nil, totalScore: nil, palaScore: nil, beneScore: nil, costScore: nil, sidePer: nil, getProductReview: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}
