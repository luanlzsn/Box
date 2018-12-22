//
//	AssetsModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class AssetsModel : NSObject, NSCoding, Mappable{

	var balance : Double?
	var createTime : String?
	var id : Int?
	var mid : Int?
	var money : Double?
	var type : Int?
	var vid : Int?


	class func newInstance(map: Map) -> Mappable?{
		return AssetsModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		balance <- map["balance"]
		createTime <- map["createTime"]
		id <- map["id"]
		mid <- map["mid"]
		money <- map["money"]
		type <- map["type"]
		vid <- map["vid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         balance = aDecoder.decodeObject(forKey: "balance") as? Double
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         mid = aDecoder.decodeObject(forKey: "mid") as? Int
         money = aDecoder.decodeObject(forKey: "money") as? Double
         type = aDecoder.decodeObject(forKey: "type") as? Int
         vid = aDecoder.decodeObject(forKey: "vid") as? Int

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
		if createTime != nil{
			aCoder.encode(createTime, forKey: "createTime")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if mid != nil{
			aCoder.encode(mid, forKey: "mid")
		}
		if money != nil{
			aCoder.encode(money, forKey: "money")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if vid != nil{
			aCoder.encode(vid, forKey: "vid")
		}

	}

}
