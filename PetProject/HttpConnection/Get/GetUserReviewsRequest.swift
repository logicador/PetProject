//
//  GetProductsRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/10.
//

import UIKit


protocol GetUserReviewsRequestProtocol {
    func response(userReviewList: [UserReview]?, getUserReviews status: String)
}


class GetUserReviewsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetUserReviewsRequestProtocol?
    let apiUrl = API_URL + "/get/user/reviews"
    
    
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
            delegate?.response(userReviewList: nil, getUserReviews: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(userReviewList: nil, getUserReviews: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(userReviewList: nil, getUserReviews: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(userReviewList: nil, getUserReviews: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(userReviewList: nil, getUserReviews: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(userReviewList: nil, getUserReviews: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(userReviewList: nil, getUserReviews: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(userReviewList: nil, getUserReviews: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(UserReviewsRequestResult.self, from: data)
                let resUserReviewList = decoded.result
                
                var userReviewList: [UserReview] = []
                for resUserReview in resUserReviewList {
                    let userReview = UserReview(id: resUserReview.pr_id, descAdv: resUserReview.pr_desc_adv, descDisadv: resUserReview.pr_desc_disadv, pId: resUserReview.p_id, pThumbnail: resUserReview.p_thumbnail)
                    userReviewList.append(userReview)
                }
                
                self.delegate?.response(userReviewList: userReviewList, getUserReviews: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(userReviewList: nil, getUserReviews: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}

