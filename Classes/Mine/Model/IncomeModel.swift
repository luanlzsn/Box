//
//	IncomeModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class IncomeModel : NSObject, NSCoding, Mappable{

	var allAsset : Double?
	var bonusRecord : BonusRecord?
	var provideName : String?
	var providePhone : String?


	class func newInstance(map: Map) -> Mappable?{
		return IncomeModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		allAsset <- map["allAsset"]
		bonusRecord <- map["bonusRecord"]
		provideName <- map["provideName"]
		providePhone <- map["providePhone"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         allAsset = aDecoder.decodeObject(forKey: "allAsset") as? Double
         bonusRecord = aDecoder.decodeObject(forKey: "bonusRecord") as? BonusRecord
         provideName = aDecoder.decodeObject(forKey: "provideName") as? String
         providePhone = aDecoder.decodeObject(forKey: "providePhone") as? String

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
		if bonusRecord != nil{
			aCoder.encode(bonusRecord, forKey: "bonusRecord")
		}
		if provideName != nil{
			aCoder.encode(provideName, forKey: "provideName")
		}
		if providePhone != nil{
			aCoder.encode(providePhone, forKey: "providePhone")
		}

	}

}
