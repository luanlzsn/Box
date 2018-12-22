//
//	UserModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class UserModel : NSObject, NSCoding, Mappable {

	var address : String?
	var code : String?
	var head : String?
	var lead : Int?
	var time : String?
	var token : String?
	var vid : Int?
	var vipLevel : Int?
	var vipName : String?
	var vipPassword : String?
	var vipPhone : String?
	var zfbName : String?
	var zfbPhone : String?


	class func newInstance(map: Map) -> Mappable?{
		return UserModel()
	}
	required init?(map: Map){}
	private override init(){}
    
    func getVipImage() -> UIImage? {
        if vipLevel ?? 0 <= kVipLevelImageArray.count {
            return UIImage(named: kVipLevelImageArray[vipLevel ?? 0])
        } else {
            return R.image.diamond_gray()
        }
    }

	func mapping(map: Map)
	{
		address <- map["address"]
		code <- map["code"]
		head <- map["head"]
		lead <- map["lead"]
		time <- map["time"]
		token <- map["token"]
		vid <- map["vid"]
		vipLevel <- map["vipLevel"]
		vipName <- map["vipName"]
		vipPassword <- map["vipPassword"]
		vipPhone <- map["vipPhone"]
		zfbName <- map["zfbName"]
		zfbPhone <- map["zfbPhone"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         address = aDecoder.decodeObject(forKey: "address") as? String
         code = aDecoder.decodeObject(forKey: "code") as? String
         head = aDecoder.decodeObject(forKey: "head") as? String
         lead = aDecoder.decodeObject(forKey: "lead") as? Int
         time = aDecoder.decodeObject(forKey: "time") as? String
         token = aDecoder.decodeObject(forKey: "token") as? String
         vid = aDecoder.decodeObject(forKey: "vid") as? Int
         vipLevel = aDecoder.decodeObject(forKey: "vipLevel") as? Int
         vipName = aDecoder.decodeObject(forKey: "vipName") as? String
         vipPassword = aDecoder.decodeObject(forKey: "vipPassword") as? String
         vipPhone = aDecoder.decodeObject(forKey: "vipPhone") as? String
         zfbName = aDecoder.decodeObject(forKey: "zfbName") as? String
         zfbPhone = aDecoder.decodeObject(forKey: "zfbPhone") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if head != nil{
			aCoder.encode(head, forKey: "head")
		}
		if lead != nil{
			aCoder.encode(lead, forKey: "lead")
		}
		if time != nil{
			aCoder.encode(time, forKey: "time")
		}
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}
		if vid != nil{
			aCoder.encode(vid, forKey: "vid")
		}
		if vipLevel != nil{
			aCoder.encode(vipLevel, forKey: "vipLevel")
		}
		if vipName != nil{
			aCoder.encode(vipName, forKey: "vipName")
		}
		if vipPassword != nil{
			aCoder.encode(vipPassword, forKey: "vipPassword")
		}
		if vipPhone != nil{
			aCoder.encode(vipPhone, forKey: "vipPhone")
		}
		if zfbName != nil{
			aCoder.encode(zfbName, forKey: "zfbName")
		}
		if zfbPhone != nil{
			aCoder.encode(zfbPhone, forKey: "zfbPhone")
		}

	}

}

class PersonalModel: NSObject, Mappable {
    
    var allAsset: Double?
    var allIncome: Double?
    var nowIncome: Double?
    var tiXian: Double?
    var vip: UserModel?
    
    class func newInstance(map: Map) -> Mappable? {
        return PersonalModel()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map) {
        allAsset <- map["allAsset"]
        allIncome <- map["allIncome"]
        nowIncome <- map["nowIncome"]
        tiXian <- map["tiXian"]
        vip <- map["vip"]
        
    }
    
    
}
