//
//	AddressModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class AddressModel : NSObject, NSCoding, Mappable{

	var content : String?
	var id : Int?
	var people : String?
	var phone : String?
	var vid : Int?


	class func newInstance(map: Map) -> Mappable?{
		return AddressModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		content <- map["content"]
		id <- map["id"]
		people <- map["people"]
		phone <- map["phone"]
		vid <- map["vid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         people = aDecoder.decodeObject(forKey: "people") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? String
         vid = aDecoder.decodeObject(forKey: "vid") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if content != nil{
			aCoder.encode(content, forKey: "content")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if people != nil{
			aCoder.encode(people, forKey: "people")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if vid != nil{
			aCoder.encode(vid, forKey: "vid")
		}

	}

}