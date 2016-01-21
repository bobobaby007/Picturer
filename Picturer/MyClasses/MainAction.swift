//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
//import SQLite
//import SwiftHTTP

//---------其他的实例类都通过该类和操作数据，该类主要访问和操作 MainAction 和 SyncAction

class MainAction: AnyObject {
    static let _album_prefix = "Album_"
    static let _ALBUM_LIST = "ALBUM_LIST"
    static var _aList:NSMutableArray?
    static var _tempAlbum:NSMutableDictionary?
    
    
    static func _checkLogOk()->Bool{
        return MainInterface._isLogined()
    }
    
    static func _showLogAt(__viewController:UIViewController){
        let _logMain:Log_Main = Log_Main()
        _logMain._delegate = __viewController as! Log_Main_delegate
        __viewController.presentViewController(_logMain, animated: true, completion: nil)
        
    }
    
    static var _albumList:NSMutableArray!{
        get{
            if _aList==nil{
                let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
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
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            _ud.setObject(_aList, forKey: _ALBUM_LIST)
             //println(_ud.dictionaryRepresentation())
        }
    }
    //-----重置
    static func _reset(){
        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        _ud.setObject(nil, forKey: _ALBUM_LIST)
        _aList = nil
    }
    //----从服务器更新图册列表
    static func _refreshAlbumListFromServer(__block:(NSDictionary)->Void){
       // _reset()
        MainInterface._getMyAlbumList { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                let ablums:NSArray = __dict.objectForKey("list") as! [NSDictionary]
                print(ablums)
                for var i:Int = 0; i < ablums.count; ++i{
                    let _album = ablums.objectAtIndex(ablums.count-1-i) as! NSDictionary
                    //print(_album)
                    
                    let _index = _getAlbumIndexOfId(_album.objectForKey("_id") as! String)
                    if _index != -1{
                        _changeAlbumAtIndex(_index, dict: _album)
                    }else{
                        //print(_album.objectForKey("title"))
                        _insertAlbum(_album)
                    }
                    dispatch_sync(dispatch_get_main_queue(), {
                        _getImagesOfAlbumIdFromServer(_album.objectForKey("_id") as! String, __block: { (__dict) -> Void in
                            
                        })
                    })
                }
                __block(__dict)
            }
        }
    }
    //----从服务器获取相册里的图片列表
    static func _getImagesOfAlbumIdFromServer(__albumId:String , __block:(NSDictionary)->Void){
        MainInterface._getImagesOfAlbum(__albumId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                let images:NSArray = __dict.objectForKey("list") as! [NSDictionary]
                let _index = _getAlbumIndexOfId(__albumId)
                if _index != -1{
                    //print("相册\(__albumId)里的图片：",images)
                    //_refreshImagesOfAlbumByIndex(images, __albumIndex: _index)
                    //_asynImagesOfAlbumByIndex(_index)
                    _changeAlbumAtIndex(_index,dict:NSDictionary(object: images, forKey: "images"))
                    
                }
                __block(__dict)
            }
        }
    }
    //--通过图册id查找图册Index
    static func _getAlbumIndexOfId(__id:String)->Int{
        for var i:Int = 0; i < MainAction._albumList.count; ++i{
            let _dict:NSDictionary = MainAction._albumList.objectAtIndex(i) as! NSDictionary
            let _id:String = _dict.objectForKey("_id") as! String
            if _id.lowercaseString.rangeOfString(__id.lowercaseString) != nil{
                return i
            }
        }
        return -1
    }
     //------通过localId查找图册Index
    static func _getAlbumIndexOfLocalId(__id:Int)->Int{
        for var i:Int = 0; i < MainAction._albumList.count; ++i{
            let _dict:NSDictionary = MainAction._albumList.objectAtIndex(i) as! NSDictionary
            let _id:Int = _dict.objectForKey("localId") as! Int
            if _id == __id{
                return i
            }
        }
        return -1
    }
    //----通过图册id提取图片
    static func _getImagesOfAlbumId(__id:String)->NSArray?{
        let _images:NSArray=[]
        let _index:Int = _getAlbumIndexOfId(__id)
        if _index>=0{
            return _getImagesOfAlbumIndex(_index)
        }
        return _images
    }
    //----分享图册通过index
    static func _shareAlbumAtIndex(index:Int){
        let _albumDict:NSMutableDictionary = NSMutableDictionary(dictionary: MainAction._albumList.objectAtIndex(index) as! NSDictionary)
        
        if _albumDict.objectForKey("_id") as! String != ""{
             let _cover = NSDictionary(objects: ["camara.png","file"], forKeys: ["url","type"])
                
                MainInterface._sendWXContentUser(_albumDict.objectForKey("title") as! String, __des: _albumDict.objectForKey("description") as! String, __url:MainInterface._albumUrl(_albumDict.objectForKey("_id") as! String), __pic: _cover)
            
        }
    }
    //----通过index获取相册
    static func _getAlbumAtIndex(index:Int)->NSDictionary?{
        let _albumDict:NSMutableDictionary = NSMutableDictionary(dictionary: MainAction._albumList.objectAtIndex(index) as! NSDictionary)
        _setDefault(_albumDict)
        return _albumDict
    }
    
    //----通过图册index获取图片数组
    static func _getImagesOfAlbumIndex(__index:Int)->NSArray?{
        let _album:NSDictionary = MainAction._getAlbumAtIndex(__index)!
        return NSMutableArray(array: _album.objectForKey("images") as! NSArray)
    }
    //----从本地添加图片到相册通过index
    static func _insertPicsToAlbumByIndex(__pics:NSArray,__albumIndex:Int){
        let _album:NSDictionary = MainAction._getAlbumAtIndex(__albumIndex)!
        let _images:NSMutableArray = NSMutableArray(array: _album.objectForKey("images") as! NSArray)
        
        for var i:Int = 0; i<__pics.count;++i{
            let _pic:NSMutableDictionary = NSMutableDictionary(dictionary: __pics.objectAtIndex(i) as! NSDictionary)
            
            if _albumHasPic(__albumIndex,__pic: _pic){
                continue
            }
            let _newPic:NSDictionary = SyncAction._uploadPicToAlbum(_pic, _album: _album)
            
            _images.insertObject(_newPic, atIndex: 0)
        }
        _changeAlbumAtIndex(__albumIndex,dict:NSDictionary(object: _images, forKey: "images"))
    }
    //----更新相册里的图片
    static func _refreshImagesOfAlbumByIndex(__pics:NSArray,__albumIndex:Int){
        let _images:NSMutableArray = NSMutableArray(array: _getImagesOfAlbumIndex(__albumIndex)!)
        for var i:Int = 0; i<__pics.count;++i{
            let _pic:NSDictionary = __pics.objectAtIndex(i) as! NSDictionary
            var _has:Bool = false
            
            for var u:Int = 0;u<_images.count;++u{
                let _image:NSMutableDictionary = NSMutableDictionary(dictionary: _images.objectAtIndex(u) as! NSDictionary)
                
                if let _id:String = _image.objectForKey("_id") as? String{
                    if _id == _pic.objectForKey("_id")  as! String{
                        for (key,value) in _pic{
                            //println(key,value)
                            if  String(value) != ""{
                                _image.setObject(value, forKey: key as! String)
                            }
                        }
                        _images[u] = _image
                        _has = true
                        break
                    }
                }
                
            }
            if !_has{
                _images.insertObject(_pic, atIndex: 0)
            }
        }
        _changeAlbumAtIndex(__albumIndex,dict:NSDictionary(object: _images, forKey: "images"))
    }
    
    //----同步到服务器，相册里的图片----＊＊＊＊＊＊＊废除使用 ，全部图片只能从服务器上下载
    static func _asynImagesOfAlbumByIndex(__albumIndex:Int){
        let _album:NSDictionary = MainAction._getAlbumAtIndex(__albumIndex)!
        let _images:NSMutableArray = NSMutableArray(array: _album.objectForKey("images") as! NSArray)
        
        for var u:Int = 0;u<_images.count;++u{
            var _image:NSMutableDictionary = NSMutableDictionary(dictionary: _images.objectAtIndex(u) as! NSDictionary)
            
            if _haOnlineId(_image){
                
            }else{
              _image = NSMutableDictionary(dictionary: SyncAction._uploadPicToAlbum(_image, _album: _album))
            }
            
            _images[u] = _image
        }
        _changeAlbumAtIndex(__albumIndex,dict:NSDictionary(object: _images, forKey: "images"))
    }
    static func _newAlbumFromeServer(__dict:NSDictionary,__block:(NSDictionary)->Void){
            var _str:String = ""
            for (key,value) in __dict{
                if String(key) == "title"{
                    _str = _str + "&title=" + String(value)
                }
                if String(key) == "description"{
                    _str = _str + "&description=" + String(value)
                }
                if String(key) == "tags"{
                    let _tags:NSArray = value as! NSArray
                    print("tags:",_tags)
                    var _tagStr:String = ""
                    for var i:Int = 0; i<_tags.count; ++i{
                        if i>0{
                            _tagStr = _tagStr + ","
                        }
                        _tagStr = _tagStr + (_tags.objectAtIndex(i) as! String)
                    }
                    _str = _str + "&tags=" + String(_tagStr)
                }
                
            }
        
        MainInterface._createAlbum(_str) { (__dict) -> Void in
            __block(__dict)
        }
    }
    //----新建相册------
    static func _insertAlbum(dict:NSDictionary){
        let _list:NSMutableArray=NSMutableArray(array:_albumList )
        let _album:NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        if _album.objectForKey("_id") == nil{
            _album.setObject("", forKey: "_id")
        }
        if _album.objectForKey("images") == nil{
            _album.setObject(NSArray(), forKey: "images")
        }
        if _album.objectForKey("title") == nil{
            _album.setObject("", forKey: "title")
        }
        let _localId:Int = Int(NSDate().timeIntervalSince1970)
        _album.setObject(_localId, forKey: "localId")
        if _album.objectForKey("last_update_at") == nil{
            _album.setObject(CoreAction._timeStrOfCurrent(), forKey: "last_update_at")
        }
        if _album.objectForKey("create_at") == nil{
            _album.setObject(CoreAction._timeStrOfCurrent(), forKey: "create_at")
        }
        _album.setObject(0, forKey: "uploaded")
        _list.insertObject(_album, atIndex: 0)
        //_albumList?.addObject(album._toDict())
        
        //------如果是来自本地命令****废除使用*****
//        if _album.objectForKey("_id") as! String == ""{
//            SyncAction._addAction(SyncAction._Type_newAlbum, __content: _album)
//        }
        //－－－－
        _albumList=_list
       // println(_albumList)
        
    }
    static func _saveTempAlbum(dict:NSDictionary){
        _tempAlbum = NSMutableDictionary(dictionary: dict)
    }
    //-----设置相册默认值-----
    static func _setDefault(_album:NSMutableDictionary){
        if _album.objectForKey("title") == nil{
            _album.setObject("", forKey: "title")
        }
        if _album.objectForKey("cover") == nil{
            _album.setObject(NSDictionary(), forKey: "cover")
        }
        
        if _album.objectForKey("counts") == nil{
            _album.setObject(0, forKey: "counts")
        }
        if _album.objectForKey("description") == nil{
            _album.setObject("", forKey: "description")
        }
        if _album.objectForKey("tags") == nil{
            _album.setObject([], forKey: "tags")
        }
        if _album.objectForKey("sort") == nil{//-------默认1，倒序
            _album.setObject(1, forKey: "sort")
        }
        if _album.objectForKey("powerType") == nil{
            _album.setObject(0, forKey: "powerType")
        }
        if _album.objectForKey("powerList") == nil{
            _album.setObject([], forKey: "powerList")
        }
        if _album.objectForKey("reply") == nil{
            _album.setObject(0, forKey: "reply")
        }
    }
    //----直接从列表里按照位置删除
    static func _deleteAlbumAtIndex(index:Int){
        let _list:NSMutableArray=NSMutableArray(array:_albumList )
        //println(index)
        let _dict:NSDictionary = _list.objectAtIndex(index) as! NSDictionary
        if let _id:String = _dict.objectForKey("_id") as? String{
            if _id != ""{
                _deleteAlbumFromServer(_dict)
            }
        }
        _list.removeObjectAtIndex(index)
        _albumList=_list
    }
    //----从服务器删除相册
    static func _deleteAlbumFromServer(__album:NSDictionary){
        SyncAction._addAction(SyncAction._Type_deleteAlbum, __content:__album)
    }
    //----获取封面
    static func _getCoverFromAlbumAtIndex(index:Int)->NSDictionary?{
        let _album:NSMutableDictionary = NSMutableDictionary(dictionary: _getAlbumAtIndex(index)!)
        if let _cover:NSDictionary = _album.objectForKey("cover") as? NSDictionary{
           return _cover
        }
        _setDefault(_album)
        let _images:NSArray = _album.objectForKey("images") as! NSArray
        if _images.count<1{
            return nil
        }
        //println(_album.objectForKey("cover"))
        
        if let _cover:NSDictionary = _album.objectForKey("cover") as? NSDictionary{
            if _albumHasPic(index,__pic: _cover){
                return _cover
            }
        }else{
            
        }
        if _album.objectForKey("sort") != nil && _album.objectForKey("sort") as! Int == 0{
            return _images.objectAtIndex(0) as? NSDictionary
        }else{
            return _images.objectAtIndex(_images.count-1) as? NSDictionary
        }
        
    }
    
    //---搜索图册
    static func _searchAlbum(__str:String)->NSArray{
        let _array:NSMutableArray = NSMutableArray()
        //print(MainAction._albumList)
        for var i:Int = 0; i < MainAction._albumList.count; ++i{
            let _dict:NSDictionary = MainAction._albumList.objectAtIndex(i) as! NSDictionary
            let _title:String = _dict.objectForKey("title") as! String
            if _title.lowercaseString.rangeOfString(__str.lowercaseString) != nil{
                _array.addObject(_dict)
            }
        }
        print(_array)
        return _array
    }
    //---判断是否有在线同步id,相册或者相片一样
    static func _haOnlineId(__dict:NSDictionary)->Bool{
        if let _id:String =  __dict.objectForKey("_id") as? String{
            if _id != ""{
                return true
            }
        }
        return false
    }
    //----检测相册里是否有某张照片
    static func _albumHasPic(__albumIndex:Int,__pic:NSDictionary)->Bool{
        let _album:NSDictionary = _getAlbumAtIndex(__albumIndex)!
        
        var _key:String = "url"
        var _value:String = ""
        var _broken:Bool = true
        
        if let __v = __pic.objectForKey("_id") as? String{
            _key = "_id"
            _value = __v
            _broken = false
        }else{
            if let __v = __pic.objectForKey("url") as? String{
                _key = "url"
                _value = __v
                _broken = false
            }
        }
        
        if _broken{
           // print("图片存在问题")
            return false
        }
        
        let _images:NSArray = _album.objectForKey("images") as! NSArray
        for var i:Int = 0 ; i<_images.count ;++i{
            
            if let _str = (_images.objectAtIndex(i) as! NSDictionary).objectForKey(_key) as? String{
                if _str == _value{
                    return true
                }
            }else{
                
            }
        }
        return false
    }
    //--------修改相册相关信息
    static func _changeAlbumAtIndex(index:Int,dict:NSDictionary){
        let _list:NSMutableArray=NSMutableArray(array:_albumList )
        let _album:NSMutableDictionary=NSMutableDictionary(dictionary: _list.objectAtIndex(index) as! NSDictionary)
        //let keys:NSArray = dict.allKeys
        
        
        for (key,value) in dict{
            //println(key,value)
            if  String(value) != ""{
                _album.setObject(value, forKey: key as! String)
            }
        }
        //_album=NSMutableDictionary(dictionary: dict)
        //println(_album)
        _list[index]=_album
        _albumList=_list
    }
    
    
    
    
    //------提交更新相册信息，除了所有的图片-----**废除使用
    
    static func _changeAlbumInfoAtIndex(index:Int,dict:NSDictionary){
        let _dict:NSMutableDictionary = NSMutableDictionary()
        let _list:NSMutableArray=NSMutableArray(array:_albumList )
         let _album:NSMutableDictionary=NSMutableDictionary(dictionary: _list.objectAtIndex(index) as! NSDictionary)
        var _str:String = ""
        for (key,value) in dict{
            //println(key,value)
            if  String(key) != "images"{
                _dict.setObject(value, forKey: key as! String)
            }
            if String(key) == "title"{
                _str = _str + "&title=" + String(value)
            }
            if String(key) == "description"{
                _str = _str + "&description=" + String(value)
            }
            if String(key) == "tags"{
                let _tags:NSArray = value as! NSArray
                print("tags:",_tags)
                var _tagStr:String = ""
                for var i:Int = 0; i<_tags.count; ++i{
                    if i>0{
                      _tagStr = _tagStr + ","
                    }
                    _tagStr = _tagStr + (_tags.objectAtIndex(i) as! String)
                }
                _str = _str + "&tags=" + String(_tagStr)
            }
            if let _albumId = _album.objectForKey("_id") as? String{
                SyncAction._addAction(SyncAction._Type_updateAlbum, __content: NSDictionary(objects: [_albumId,_str], forKeys: ["_id","changeingStr"]))
            }
        }
       
        _changeAlbumAtIndex(index, dict: _dict)
    }
    
    //-------修改相册信息到服务器
    static func _changeAlbumOfId(__id:String,dict:NSDictionary,__block:(NSDictionary)->Void){
        var _str:String = ""
        for (key,value) in dict{
            
            if String(key) == "title"{
                _str = _str + "&title=" + String(value)
            }
            if String(key) == "description"{
                _str = _str + "&description=" + String(value)
            }
            if String(key) == "tags"{
                let _tags:NSArray = value as! NSArray
                print("tags:",_tags)
                var _tagStr:String = ""
                for var i:Int = 0; i<_tags.count; ++i{
                    if i>0{
                        _tagStr = _tagStr + ","
                    }
                    _tagStr = _tagStr + (_tags.objectAtIndex(i) as! String)
                }
                _str = _str + "&tags=" + String(_tagStr)
            }
            
        }
        MainInterface._changeAlbum(__id, __changeingStr: _str, __block: { (__dict) -> Void in
            __block(__dict)
        })
    }
    
    
    
    //----通过图片localId添加在线id,图片上传完肯定有相册id
    static func _changeOnlineIdOfPicByLocalId(__localId:Int,__onlineId:String){
        let _indexPath:NSIndexPath = _getPathOfPicByLoacleId(__localId)
        print(_indexPath.row)
        
    }
    //------通过图片localId获取图册和图片对应index
    static func _getPathOfPicByLoacleId(__localId:Int)->NSIndexPath{
        for var i:Int = 0; i < MainAction._albumList.count; ++i{
            let _album:NSDictionary = MainAction._albumList.objectAtIndex(i) as! NSDictionary
            let _images:NSMutableArray = NSMutableArray(array: _album.objectForKey("images") as! NSArray)
            for var _d:Int = 0; _d<_images.count ; ++_d{
                let _img:NSDictionary = _images.objectAtIndex(_d) as! NSDictionary
                if let _localId:Int = _img.objectForKey("localId") as? Int{
                    if _localId == __localId{
                        return NSIndexPath(forRow: i, inSection: _d)
                    }
                }
            }
        }
        return NSIndexPath(forRow: -1, inSection: -1)
    }
    
    //------修改相册里的某张图片------******作废使用
    static func _changePicAtAlbum(index:Int,albumIndex:Int,dict:NSDictionary){
        let _album:NSDictionary = MainAction._getAlbumAtIndex(albumIndex)!
        let _images:NSMutableArray = NSMutableArray(array: _album.objectForKey("images") as! NSArray)
        let _img:NSMutableDictionary = NSMutableDictionary(dictionary: _images.objectAtIndex(index) as! NSDictionary)
        var _str:String = ""
        for (key,value) in dict{
            //println(key,value)
            if String(key) == "title"{
                _str = _str + "&title=" + String(value)
            }
            if String(key) == "description"{
                _str = _str + "&description=" + String(value)
            }
            
            
            _img.setObject(value, forKey: key as! String)
            
            
        }
        if _str != ""{
            if let _picId = _album.objectForKey("_id") as? String {
                SyncAction._addAction(SyncAction._Type_updatePic, __content: NSDictionary(objects: [_picId,_str], forKeys: ["_id","changeingStr"]))
            }
        }
        _images[index] = _img
        _changeAlbumAtIndex(albumIndex, dict: NSDictionary(object: _images, forKey: "images"))
    }
    
    //------修改图片
    static func _changePic(dict:NSDictionary,__block:(NSDictionary)->Void){
            var _str:String = ""
            for (key,value) in dict{
                //println(key,value)
                if String(key) == "title"{
                    _str = _str + "&title=" + String(value)
                }
                if String(key) == "description"{
                    _str = _str + "&description=" + String(value)
                }
                if String(key) == "tags"{
                    let _tags:NSArray = value as! NSArray
                   // print("tags:",_tags)
                    var _tagStr:String = ""
                    for var i:Int = 0; i<_tags.count; ++i{
                        if i>0{
                            _tagStr = _tagStr + ","
                        }
                        _tagStr = _tagStr + (_tags.objectAtIndex(i) as! String)
                    }
                    _str = _str + "&tags=" + String(_tagStr)
                }
                if String(key) == "album"{
                    _str = _str + "&album=" + String(value)
                }
            }
            if let _picId:String = dict.objectForKey("_id") as? String {
                MainInterface._changePic(_picId, __changeingStr: _str, __block: { (__dict) -> Void in
                    __block(__dict)
                })
            }else{
                __block(NSDictionary(objects: [-10], forKeys: ["recode"]))
            }
        
        
    }
    
    
    //----获取相册里某图片的index
    static func _getPicIndexAtAlbumById(__id:String,albumIndex:Int)->Int{
        let _album:NSDictionary = MainAction._getAlbumAtIndex(albumIndex)!
        let _images:NSMutableArray = NSMutableArray(array: _album.objectForKey("images") as! NSArray)
        for var i:Int = 0; i < _images.count; ++i{
            let _dict:NSDictionary = _images.objectAtIndex(i) as! NSDictionary
            let _id:String = _dict.objectForKey("_id") as! String
            if _id.lowercaseString.rangeOfString(__id.lowercaseString) != nil{
                return i
            }
        }
        return -1
    }
    
    //----判断返回数据是否正确
    static func _getResultRight(__dict:NSDictionary)->Bool{
        if __dict.objectForKey("recode") as! Int == 200{
            return true
        }
        
        return false
    }
    
}
    

