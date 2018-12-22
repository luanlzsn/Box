//
//	BonusRecord.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BonusRecord : NSObject, NSCoding, Mappable{

	var balance : Double?
	var grantTime : String?
	var id : Int?
	var money : Double?
	var orderNum : String?
	var type : Int?
	var vipLevel : String?
	var vipName : String?
	var vipPhone : String?
	var vtid : Int?


	class func newInstance(map: Map) -> Mappable?{
		return BonusRecord()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		balance <- map["balance"]
		grantTime <- map["grantTime"]
		id <- map["id"]
		money <- map["money"]
		orderNum <- map["orderNum"]
		type <- map["type"]
		vipLevel <- map["vipLevel"]
		vipName <- map["vipName"]
		vipPhone <- map["vipPhone"]
		vtid <- map["vtid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         balance = aDecoder.decodeObject(forKey: "balance") as? Double
         grantTime = aDecoder.decodeObject(forKey: "grantTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         money = aDecoder.decodeObject(forKey: "money") as? Double
         orderNum = aDecoder.decodeObject(forKey: "orderNum") as? String
         type = aDecoder.decodeObject(forKey: "type") as? Int
         vipLevel = aDecoder.decodeObject(forKey: "vipLevel") as? String
         vipName = aDecoder.decodeObject(forKey: "vipName") as? String
         vipPhone = aDecoder.decodeObject(forKey: "vipPhone") as? String
         vtid = aDecoder.decodeObject(forKey: "vtid") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if balance != nil{
			aCoder.encode(balance, forKey: "balance")
		}
		if grantTime != nil{
			aCoder.encode(grantTime, forKey: "grantTime")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if money != nil{
			aCoder.encode(money, forKey: "money")
		}
		if orderNum != nil{
			aCoder.encode(orderNum, forKey: "orderNum")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if vipLevel != nil{
			aCoder.encode(vipLevel, forKey: "vipLevel")
		}
		if vipName != nil{
			aCoder.encode(vipName, forKey: "vipName")
		}
		if vipPhone != nil{
			aCoder.encode(vipPhone, forKey: "vipPhone")
		}
		if vtid != nil{
			aCoder.encode(vtid, forKey: "vtid")
		}

	}

}
