//
//	TaskRecordModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class TaskRecordModel : NSObject, NSCoding, Mappable{

	var id : Int?
	var putTime : String?
	var status : Int?//任务状态 0: 待提交 1：待审核 2:已完成 3:审核失败
	var tName : String?
	var tid : Int?
    var money : Double?


	class func newInstance(map: Map) -> Mappable?{
		return TaskRecordModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["id"]
		putTime <- map["putTime"]
		status <- map["status"]
		tName <- map["tName"]
		tid <- map["tid"]
        money <- map["money"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         putTime = aDecoder.decodeObject(forKey: "putTime") as? String
         status = aDecoder.decodeObject(forKey: "status") as? Int
         tName = aDecoder.decodeObject(forKey: "tName") as? String
         tid = aDecoder.decodeObject(forKey: "tid") as? Int
         money = aDecoder.decodeObject(forKey: "money") as? Double

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if putTime != nil{
			aCoder.encode(putTime, forKey: "putTime")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if tName != nil{
			aCoder.encode(tName, forKey: "tName")
		}
		if tid != nil{
			aCoder.encode(tid, forKey: "tid")
		}
        if money != nil{
            aCoder.encode(money, forKey: "money")
        }

	}

}
