//
//	TaskModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class TaskModel : NSObject, NSCoding, Mappable{

	var content : String?
	var createTime : String?
	var creator : String?
	var image : String?
	var objIds : String?
	var tName : String?
	var tid : Int?
    var status : Int?//是否领取 0:未领取 1：已领取


	class func newInstance(map: Map) -> Mappable?{
		return TaskModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		content <- map["content"]
		createTime <- map["createTime"]
		creator <- map["creator"]
		image <- map["image"]
		objIds <- map["objIds"]
		tName <- map["tName"]
		tid <- map["tid"]
        status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         creator = aDecoder.decodeObject(forKey: "creator") as? String
         image = aDecoder.decodeObject(forKey: "image") as? String
         objIds = aDecoder.decodeObject(forKey: "objIds") as? String
         tName = aDecoder.decodeObject(forKey: "tName") as? String
         tid = aDecoder.decodeObject(forKey: "tid") as? Int
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
		if createTime != nil{
			aCoder.encode(createTime, forKey: "createTime")
		}
		if creator != nil{
			aCoder.encode(creator, forKey: "creator")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if objIds != nil{
			aCoder.encode(objIds, forKey: "objIds")
		}
		if tName != nil{
			aCoder.encode(tName, forKey: "tName")
		}
		if tid != nil{
			aCoder.encode(tid, forKey: "tid")
		}
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }

	}

}
