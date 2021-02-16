//
//  GetNoticesRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/16.
//

import UIKit


protocol GetNoticesRequestProtocol {
    func response(noticeList: [Notice]?, getNotices status: String)
}


class GetNoticesRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetNoticesRequestProtocol?
    let apiUrl = API_URL + "/get/notices"
    
    
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
            delegate?.response(noticeList: nil, getNotices: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(noticeList: nil, getNotices: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(noticeList: nil, getNotices: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(noticeList: nil, getNotices: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(noticeList: nil, getNotices: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(noticeList: nil, getNotices: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(noticeList: nil, getNotices: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(noticeList: nil, getNotices: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(NoticesRequestResult.self, from: data)
                
                let result = decoded.result
                
                let resNoticeList = result
                
                var noticeList: [Notice] = []
                for resNotice in resNoticeList {
                    let notice = Notice(id: resNotice.no_id, title: resNotice.no_title, contents: resNotice.no_contents, createdDate: resNotice.no_created_date, updatedDate: resNotice.no_updated_date)
                    noticeList.append(notice)
                }
                
                self.delegate?.response(noticeList: noticeList, getNotices: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(noticeList: nil, getNotices: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}

