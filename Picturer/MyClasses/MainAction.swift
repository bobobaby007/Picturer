//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

enum _Action_Type:Int{
    case NewAlbum = 1
    case PicsIn
}


class MainAction: AnyObject {
    static let _album_prefix = "Album_"
    static let _ALBUM_LIST = "ALBUM_LIST"
    static var _aList:NSMutableArray?
    
    
    
    
    static var _albumList:NSMutableArray!{
        get{
            if _aList==nil{
                let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                var _list:NSMutableArray?=_ud.valueForKey(_ALBUM_LIST) as? NSMutableArray
                println(_list)
                if _list==nil{
                    _list = NSMutableArray(array: [])
                    _ud.setObject(_list, forKey: _ALBUM_LIST)
                }
                _aList = _list
            }
            return _aList
        }
        set{
            _aList=newValue
        }
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