//
//  Extension.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit
import SystemConfiguration
import Photos


// MARK: UIViewController
extension UIViewController: UIScrollViewDelegate {
    
    func changeRootViewController(rootViewController: UIViewController, duration: CFTimeInterval = 0.2) {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = duration
        view.window?.layer.add(transition, forKey: kCATransition)
        self.view.window?.rootViewController = rootViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showNetworkAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "네트워크 오류", message: "네트워크가 연결중인지 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "다시시도", style: UIAlertAction.Style.default, handler: { (_) in
                self.changeRootViewController(rootViewController: LaunchViewController())
            }))
            self.present(alert, animated: true)
        }
    }
    
    func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showIndicator(idv: UIActivityIndicatorView, bov: UIVisualEffectView) {
        view.addSubview(bov)
        bov.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bov.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bov.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bov.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.addSubview(idv)
        idv.centerXAnchor.constraint(equalTo: bov.centerXAnchor).isActive = true
        idv.centerYAnchor.constraint(equalTo: bov.centerYAnchor).isActive = true
        idv.startAnimating()
    }
    func hideIndicator(idv: UIActivityIndicatorView, bov: UIVisualEffectView) {
        idv.stopAnimating()
        idv.removeView()
        bov.removeView()
    }
    
    func checkPhotoGallaryAvailable(allow: (() -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined || status == .denied {
            PHPhotoLibrary.requestAuthorization({ (status) in DispatchQueue.main.async {
                if status == .notDetermined || status == .denied {
                    let alert = UIAlertController(title: "앨범 액세스 허용하기", message: "'펫프로젝트'에서 앨범에 접근하고자 합니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
                    alert.addAction(UIAlertAction(title: "설정", style: UIAlertAction.Style.default, handler: { (_) in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }))
                    self.present(alert, animated: true)
                    return
                }
                allow?()
            }})
            return
        }
        allow?()
    }
    
    func showErrorAlert(title: String?, message: String? = "오류가 발생했습니다. 고객센터에 문의해주세요.\n\n평일 10:00-17:00\n15xx-xxxx", buttonText: String = "확인", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.cancel, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
        
        view.endEditing(true)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func isValidString(min: Int, utf8Min: Int, max: Int, utf8Max: Int, value: String) -> Bool {
        if value.count > max && value.utf8.count > utf8Max { return false }
        if value.count < min && value.utf8.count < utf8Min { return false }
        return true
    }
    
    func rangeString(len: Int, value: String, isDot: Bool = false) -> String {
        if value.count < len { return value }
        let range = value.index(value.startIndex, offsetBy: 0) ... value.index(value.startIndex, offsetBy: len - 1)
        return "\(String(value[range]))\(isDot ? "..." : "")"
    }
    
    func getMonthAge(birth: Int) -> Int {
        guard let birthDate = String(birth).toDate(dateFormat: "YYYYMMDD") else { return 0 }
        let now = Date()
        let month = Calendar.current.dateComponents([.month], from: birthDate, to: now).month
        return month ?? 0
    }
}


// MARK: UIView
extension UIView {
    func removeAllChildView() {
        for view in self.subviews {
            NSLayoutConstraint.deactivate(view.constraints)
            view.removeFromSuperview()
        }
    }
    
    func removeView() {
        NSLayoutConstraint.deactivate(self.constraints)
        self.removeFromSuperview()
    }
}


// MARK: UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static let mainColor = UIColor(hexString: "#00C07B")
    static let warningColor = UIColor(hexString: "#FF8041")
}


// MARK: String
extension String {
    func toDate(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // YYYY-MM-dd HH:mm:ss
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}


// MARK: NSMutableAttributedString
extension NSMutableAttributedString {
    func bold(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }

    func normal(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
    
    func thin(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize, weight: .thin)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
}


// MARK: UILabel
extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}


// MARK: Int
extension Int {
    func intComma() -> String {
        let value: NSNumber = self as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        guard let resultValue = formatter.string(from: value) else { return "" }
        return resultValue
    }
    
    func monthAge() -> Int {
        guard let birthDate = String(self).toDate(dateFormat: "YYYYMMDD") else { return 0 }
        let now = Date()
        let month = Calendar.current.dateComponents([.month], from: birthDate, to: now).month
        return month ?? 0
    }
}

