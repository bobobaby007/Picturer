//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit




class MainAction: AnyObject {
    static let _album_prefix = "Album_"
    static let _ALBUM_LIST = "ALBUM_LIST"
    static var _aList:NSMutableArray?
    
    static var _albumList:NSMutableArray!{
        get{
            if _aList==nil{
                var _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                var _list:NSMutableArray?=_ud.valueForKey(_ALBUM_LIST) as? NSMutableArray
                //println(_list)
                if _list==nil{
                    _list = NSMutableArray(array: [])
                    _ud.setObject(_list, forKey: _ALBUM_LIST)
                }
                _aList = _list
            }
            return _aList
        }
        set{
            //println("set")
            _aList=newValue
            var _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            _ud.setObject(_aList, forKey: _ALBUM_LIST)
             //println(_ud.dictionaryRepresentation())
        }
    }
    
    
    static func _getImagesOfAlbumId(__id:String)->NSArray?{
        var _images:NSArray=[]
//        let _albumPlist:NSDictionary? = CoreAction._loadPlist(__id)
//        if _albumPlist == nil{
//           return nil
//        }else{
//            let _album:NSDictionary = _albumPlist?.objectForKey("root") as! NSDictionary
//            return _images
//        }
        return _images
    }
    static func _getImagesOfAlbumIndex(__index:Int)->NSArray?{
        let _album:NSDictionary = MainAction._getAlbumAtIndex(__index)!
        return NSMutableArray(array: _album.objectForKey("images") as! NSArray)
    }
    
    static func _savePicToAlbumById(__pic:NSDictionary,__albumId:String){
        
    }
    static func _insertAlbum(dict:NSDictionary)->String{
        var _list:NSMutableArray=NSMutableArray(array:_albumList )
        var _album:NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        
        var _id:String="1234555"
        _album.setObject(_id, forKey: "id")
        _album.setObject(_id, forKey: "last_update_at")
        _album.setObject(_id, forKey: "create_at")
        _album.setObject(0, forKey: "uploaded")
        _list.insertObject(_album, atIndex: 0)
        //_albumList?.addObject(album._toDict())
        _albumList=_list
       // println(_albumList)
        return _id
    }
    static func _getAlbumAtIndex(index:Int)->NSDictionary?{
        let _albumDict:NSDictionary = MainAction._albumList.objectAtIndex(index) as! NSDictionary
        return _albumDict
    }
    //----直接从列表里按照位置删除
    static func _deleteAlbumAtIndex(index:Int){
        var _list:NSMutableArray=NSMutableArray(array:_albumList )
        //println(index)
        _list.removeObjectAtIndex(index)
        _albumList=_list
    }
    
    static func _changeAlbumAtIndex(index:Int,dict:NSDictionary){
        var _list:NSMutableArray=NSMutableArray(array:_albumList )
        var _album:NSMutableDictionary=_list[index] as! NSMutableDictionary
        
        //let keys:NSArray = dict.allKeys
        
        for (key,value) in dict{
            //println(key,value)
            _album.setObject(value, forKey: key as! String)
        }
        
        //_album=NSMutableDictionary(dictionary: dict)
        
        
        //println(_album)
        
        _list[index]=_album
        _albumList=_list
    }
    
}











////////////////////////////


class CoverObj:AnyObject {
    var thumbImage:String=String()
    func _toDict()->NSDictionary{
       return NSDictionary(objects: [thumbImage], forKeys: ["thumbImage"])
    }
}

class AlbumObj: AnyObject {
    var id:String=String()
    var cover:CoverObj=CoverObj()
    var title:String=String()
    var thumbImage:String=String()
    var images:NSMutableArray=[]
    var reply:String=String()
    var des:String=String()
    
    func _toDict()->NSDictionary{
        var _dict:NSMutableDictionary=NSMutableDictionary(objects: [thumbImage,title,id,des,reply], forKeys: ["thumbImage","title","id","des","reply"])
        
        _dict.setObject(cover._toDict(), forKey: "cover")
        
//        var _imagesArray:NSMutableArray=[]
//        var _count:Int = images.count
//        for var i = 0; i<_count; ++i{
//            _imagesArray[i]=(images[i] as! PicObj)._toDict()
//        }
//        _dict.setObject(_imagesArray, forKey: "images")
        
        return _dict
    }
}

class PicObj:AnyObject {
    var type:String=String()
    var thumbImage:String=String()
    var originalImage:String=String()
    var refreshed:Bool=false
    var pid:String=String()
    var url:String=String()
    
    
    
    
    func _toDict()->NSDictionary{
        return NSDictionary(objects: [thumbImage,originalImage,refreshed,pid,url], forKeys: ["thumbImage","originalImage","refreshed","pid","url"])
    }
}