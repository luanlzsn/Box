//
//	ExtractModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ExtractModel : NSObject, NSCoding, Mappable{

	var allAsset : Double?
	var balance : Double?
	var id : Int?
	var money : Double?
	var orderNum : String?
	var status : Int?
	var time : String?
	var vid : Int?
	var zfbPhone : String?


	class func newInstance(map: Map) -> Mappable?{
		return ExtractModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		allAsset <- map["allAsset"]
		balance <- map["balance"]
		id <- map["id"]
		money <- map["money"]
		orderNum <- map["orderNum"]
		status <- map["status"]
		time <- map["time"]
		vid <- map["vid"]
		zfbPhone <- map["zfbPhone"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         allAsset = aDecoder.decodeObject(forKey: "allAsset") as? Double
         balance = aDecoder.decodeObject(forKey: "balance") as? Double
         id = aDecoder.decodeObject(forKey: "id") as? Int
         money = aDecoder.decodeObject(forKey: "money") as? Double
         orderNum = aDecoder.decodeObject(forKey: "orderNum") as? String
         status = aDecoder.decodeObject(forKey: "status") as? Int
         time = aDecoder.decodeObject(forKey: "time") as? String
         vid = aDecoder.decodeObject(forKey: "vid") as? Int
         zfbPhone = aDecoder.decodeObject(forKey: "zfbPhone") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if allAsset != nil{
			aCoder.encode(allAsset, forKey: "allAsset")
		}
		if balance != nil{
			aCoder.encode(balance, forKey: "balance")
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
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if time != nil{
			aCoder.encode(time, forKey: "time")
		}
		if vid != nil{
			aCoder.encode(vid, forKey: "vid")
		}
		if zfbPhone != nil{
			aCoder.encode(zfbPhone, forKey: "zfbPhone")
		}

	}

}
