//
//	BannerModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BannerModel : NSObject, NSCoding, Mappable{

	var cover : String?
	var id : Int?
	var status : Int?
	var url : String?


	class func newInstance(map: Map) -> Mappable?{
		return BannerModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		cover <- map["cover"]
		id <- map["id"]
		status <- map["status"]
		url <- map["url"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cover = aDecoder.decodeObject(forKey: "cover") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         status = aDecoder.decodeObject(forKey: "status") as? Int
         url = aDecoder.decodeObject(forKey: "url") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cover != nil{
			aCoder.encode(cover, forKey: "cover")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}

	}

}