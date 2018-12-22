//
//  Common.swift
//  MoFan
//
//  Created by luan on 2016/12/8.
//  Copyright © 2016年 luan. All rights reserved.
//

import UIKit
import SwifterSwift

class Common: NSObject {
    
    //MARK: - 中文转拼音
    class func chineseToPinyin(chinese: String) -> String {
        let mutableString = NSMutableString(string: chinese)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return mutableString.replacingOccurrences(of: " ", with: "")
    }
    
    // MARK: - 校验手机号
    class func isValidateMobile(mobile: String) -> Bool {
        return validateStringByPattern(str: mobile, pattern: "^((13[0-9])|(15[^4,\\D])|(17[0,0-9])|(18[0,0-9]))\\d{8}$")
    }
    
    // MARK: - 校验邮箱
    class func isValidateEmail(email: String) -> Bool {
        return validateStringByPattern(str: email, pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-_]+\\.[A-Za-z]{2,4}")
    }
    
    // MARK: - 校验邮箱
    class func isValidateURL(urlStr: String) -> Bool {
        return validateStringByPattern(str: urlStr, pattern: "http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?")
    }
    
    // MARK: - 校验数字
    class func isValidateNumber(numberStr: String) -> Bool {
        return validateStringByPattern(str: numberStr, pattern: "^[0-9]*$")
    }
    
    // MARK: - 校验金钱
    class func isValidateMoney(moneyStr: String) -> Bool {
        return validateStringByPattern(str: moneyStr, pattern: "^[0-9.]*$")
    }
    
    // MARK: - 校验身份证号码
    class func isIdNumber(idNumber: String) -> Bool {
        return validateStringByPattern(str: idNumber, pattern: "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)")
    }
    
    // MARK: - 校验登录密码强度
    class func isCheckPasswordStrong(password: String) -> Bool {
        return validateStringByPattern(str: password, pattern: "^(?=.*\\d)(?=.*[a-zA-Z]).{6,20}$")
    }
    
    // MARK: - 根据正则表达式校验字符串
    class func validateStringByPattern(str: String, pattern: String) -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let matches = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    //MARK: - 将字符串根据格式转换为日期
    class func obtainDateWithStr(str: String, formatterStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        let date = formatter.date(from: str)
        return (date != nil) ? date! : Date()
    }
    
    //MARK: - 根据日期和格式获取字符串
    class func obtainStringWithDate(date: Date, formatterStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        return formatter.string(from: date)
    }
    
    //MARK: - md5加密
    class func md5String(str:String) -> String {
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    // MARK: 根据属性对对象数组进行排序
    class func sortArray(array: [Any], descriptor: String, ascending: Bool) -> [Any] {
        let sortDescriptor = NSSortDescriptor.init(key: descriptor, ascending: ascending)
        return (array as NSArray).sortedArray(using: [sortDescriptor])
    }
    
    //MARK: - 需要登录之后才能执行的操作判断是否可以操作，返回YES可以继续操作，否则自动跳转到登录
//    class func checkIsOperation(controller : UIViewController) -> Bool {
//        if JCManage.isLogin {
//            return true
//        } else {
//            let login = R.storyboard.login().instantiateInitialViewController()!
//            controller.present(login, animated: true, completion: nil)
//            return false
//        }
//    }
    
    //MARK: - 校验是否是空字符串
    class func isBlankString(str: String?) -> Bool {
        if str == nil || str!.isEmpty {
            return true
        }
        if str!.trimmingCharacters(in: NSCharacterSet.controlCharacters).isEmpty {
            return true
        }
        return false
    }
    
    // MARK: - 判断controller是否正在显示
    class func isVisibleWithController(_ controller: UIViewController) -> Bool {
        return (controller.isViewLoaded && controller.view.window != nil)
    }
    
    // MARK: - 获取token字符串
    class func getDeviceTokenStringWithDeviceToken(deviceToken: Data) -> String {
        return deviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
    }
    
    // MARK: - 判断是否需要显示新手引导
    class func checkGuide() -> Bool {
        let path = Bundle.main.path(forResource: "Guide", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)!
        let isShowGuide = dic["showGuide"] as! String
        if isShowGuide == "1" {
            if let version = UserDefaults.standard.object(forKey: "Version") as? String {
                if version.int! < (dic["version"] as! String).int! {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            UserDefaults.standard.setValue(dic["version"]!, forKey: "Version")
            UserDefaults.standard.synchronize()
            return false
        }
    }
    
    // MARK: - 新手引导完成
    class func guideComplete() {
        let path = Bundle.main.path(forResource: "Guide", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)!
        UserDefaults.standard.setValue(dic["version"]!, forKey: "Version")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - 递归
    class func recursive(n: Int) -> Double {
        if n <= 0 {
            return 1
        } else {
            return Double(n) * recursive(n: n - 1)
        }
    }
    
    // MARK: - 随机生成不重复的Int数组
    class func randomNonRepetitionNumber(startArray: [Int], number: Int) -> [Int] {
        var array = startArray
        var resultArr = [Int]()
        for i in 0..<number {
            let currentCount = UInt32(array.count - i)
            let index = Int(arc4random_uniform(currentCount))
            resultArr.append(array[index])
            array[index] = array[Int(currentCount) - 1]
        }
        return resultArr
    }
    
    // MARK: - 格式化金钱
    class func formatMoney(money: String) -> String {
        if money.isNumeric {
            let format = NumberFormatter()
            format.numberStyle = .decimal
            let number = NSNumber(value: money.double() ?? 0)
            return format.string(from: number) ?? "0"
        } else {
            return "0"
        }
    }
    
    // MARK: - 校验密码等级
    class func checkPasswordLevel(password: String) -> Int {
        var level = 0
        if password.count >= 8 {
            level += 1
        }
        if validateStringByPattern(str: password, pattern: "[0-9]") == true {
            level += 1
        }
        if validateStringByPattern(str: password, pattern: "[a-z]") == true {
            level += 1
        }
        if validateStringByPattern(str: password, pattern: "[A-Z]") == true {
            level += 1
        }
        if validateStringByPattern(str: password, pattern: "[^0-9A-Za-z]") == true {
            level += 1
        }
        return level
    }
    
    // MARK: - 将字符串转换为字典
    class func getDictionaryFromJSONString(jsonString: String) -> NSDictionary {
        let jsonData: Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    
    // MARK: - 传进去字符串,生成二维码图片
    class func setupQRCodeImage(_ text: String, size: CGFloat) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: size)
            return qrCodeImage
        }
        
        return UIImage()
    }
    
    // MARK: - 生成高清的UIImage
    class func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    // MARK: - 暂未开放提示
    class func functionNotOpen(viewController: UIViewController) {
        let alert = UIAlertController(title: NSLocalizedString("此功能即将上线，敬请期待！", comment: ""), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func intIntoString(number: Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let string: String = formatter.string(for: number) ?? ""
        return string
    }

}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return self.borderColor
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}

extension UITextField {
    @IBInspectable
    var leftImage: UIImage {
        get {
            return self.leftImage
        }
        set {
            let imgView = UIImageView(image: newValue)
            imgView.contentMode = .center
            imgView.frame = CGRect(x: 15, y: 0, width: newValue.size.width, height: height)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue.size.width + 30, height: height))
            view.addSubview(imgView)
            leftView = view
            leftViewMode = .always
        }
    }
    
    @IBInspectable
    var rightImage: UIImage {
        get {
            return self.rightImage
        }
        set {
            let imgView = UIImageView(image: newValue)
            imgView.contentMode = .center
            imgView.frame = CGRect(x: 15, y: 0, width: newValue.size.width, height: height)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: newValue.size.width + 30, height: height))
            view.addSubview(imgView)
            rightView = view
            rightViewMode = .always
        }
    }
}

extension UITableView {
    func showNoDataWithImage(image: UIImage, title: String) {
        hiddenNoData()
        let imgView = UIImageView(image: image)
        imgView.size = image.size
        imgView.center.x = SwifterSwift.screenWidth / 2.0
        imgView.center.y = height * 0.5 * 0.75
        addSubview(imgView)
        
        let label = UILabel(text: title)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hexString: "999999")
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: imgView.y + imgView.height + 30, width: SwifterSwift.screenWidth, height: 20)
        addSubview(label)
    }
    
    func hiddenNoData() {
        for view in subviews {
            if view.isKind(of: UILabel.classForCoder()) || view.isKind(of: UIImageView.classForCoder()) {
                view.removeSubviews()
            }
        }
    }
    
    func setAndLayout(tableHeaderView header: UIView) {
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableHeaderView = header
    }
    
    func setFooterAndLayout(tableFooterView footer: UIView) {
        footer.setNeedsLayout()
        footer.layoutIfNeeded()
        footer.frame.size = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableFooterView = footer
    }
}

