//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation

class MainAction: AnyObject {
    static let _album_prefix = "Album_"
    
    static var _albumList:NSMutableArray?
    
    
    class func _getAlbumList {
        
    }
}


class CoverObj:AnyObject {
    var thumbImage:String=String()
    func _toDict()->NSDictionary{
       return NSDictionary(objects: [thumbImage], forKeys: ["thumbImage"])
    }
}

class AlbumObj: AnyObject {
    var cover:CoverObj=CoverObj()
    var title:String=String()
    var thumbImage:String=String()
    var images:NSMutableArray=[]
    func _toDict()->NSDictionary{
        var _dict:NSMutableDictionary=NSMutableDictionary(objects: [thumbImage,title], forKeys: ["thumbImage","title"])
        _dict.setObject(cover._toDict(), forKey: "cover")
        
        var _imagesArray:NSMutableArray=[]
        var _count:Int = images.count
        for var i = 0; i<_count; ++i{
            _imagesArray[i]=(images[i] as! PicObj)._toDict()
        }
        _dict.setObject(_imagesArray, forKey: "images")
        return _dict
    }
}

class PicObj:AnyObject {
    var thumbImage:String=String()
    var originalImage:String=String()
    var refreshed:Bool=false
    var pid:String=String()
    func _toDict()->NSDictionary{
        return NSDictionary(objects: [thumbImage,originalImage,refreshed,pid], forKeys: ["thumbImage","originalImage","refreshed","pid"])
    }
}