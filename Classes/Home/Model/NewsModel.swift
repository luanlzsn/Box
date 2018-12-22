//
//	NewsModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NewsModel : NSObject, NSCoding, Mappable{

	var content : String?
	var id : Int?
	var status : Int?


	class func newInstance(map: Map) -> Mappable?{
		return NewsModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		content <- map["content"]
		id <- map["id"]
		status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         status = aDecoder.decodeObject(forKey: "status") as? Int

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
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}