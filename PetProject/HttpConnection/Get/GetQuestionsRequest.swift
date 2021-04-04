//
//  GetSymptomDetailRequest.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/18.
//

import UIKit


protocol GetQuestionsRequestProtocol {
    func response(questionList: [Question]?, getQuestions status: String)
}


class GetQuestionsRequest: HttpRequest {
    
    // MARK: Property
    var delegate: GetQuestionsRequestProtocol?
    let apiUrl = API_URL + "/get/questions"
    
    
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
            delegate?.response(questionList: nil, getQuestions: "ERR_URL_ENCODE")
            return
        }
        
        guard let url = URL(string: encodedUrlString) else {
            if isShowAlert { vc.showErrorAlert(title: "ERR_URL") }
            delegate?.response(questionList: nil, getQuestions: "ERR_URL")
            return
        }
        
        let httpRequest = url
        
        let conf = URLSessionConfiguration.default
        conf.waitsForConnectivity = true
        conf.timeoutIntervalForResource = HTTP_TIMEOUT
        let task = URLSession(configuration: conf).dataTask(with: httpRequest, completionHandler: { (data, response, error) in DispatchQueue.main.async {
                
            if let _ = error {
                if isShowAlert { vc.showErrorAlert(title: "ERR_SERVER") }
                self.delegate?.response(questionList: nil, getQuestions: "ERR_SERVER")
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_RESPONSE") }
                self.delegate?.response(questionList: nil, getQuestions: "ERR_RESPONSE")
                return
            }
            
            if res.statusCode != 200 {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_CODE") }
                self.delegate?.response(questionList: nil, getQuestions: "ERR_STATUS_CODE")
                return
            }
            
            guard let data = data else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA") }
                self.delegate?.response(questionList: nil, getQuestions: "ERR_DATA")
                return
            }
            
            guard let status = self.getStatusCode(data: data) else {
                if isShowAlert { vc.showErrorAlert(title: "ERR_STATUS_DECODE") }
                self.delegate?.response(questionList: nil, getQuestions: "ERR_STATUS_DECODE")
                return
            }
            
            if status != "OK" {
                if isShowAlert { vc.showErrorAlert(title: status) }
                self.delegate?.response(questionList: nil, getQuestions: status)
                return
            }
            
            // MARK: Response
            do {
                let decoded = try JSONDecoder().decode(QuestionsRequestResult.self, from: data)
                let resQuestionList = decoded.result
                
                var questionList: [Question] = []
                for resQuestion in resQuestionList {
                    let question = Question(id: resQuestion.q_id, contents: resQuestion.q_contents, status: resQuestion.q_status, answer: resQuestion.q_answer, createdDate: resQuestion.q_created_date, answeredDate: resQuestion.q_answered_date)
                    questionList.append(question)
                }
                
                self.delegate?.response(questionList: questionList, getQuestions: "OK")
                
            } catch {
                if isShowAlert { vc.showErrorAlert(title: "ERR_DATA_DECODE", message: "데이터 응답 오류가 발생했습니다.") }
                self.delegate?.response(questionList: nil, getQuestions: "ERR_DATA_DECODE")
            }
        }})
        task.resume()
    }
}

