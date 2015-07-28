//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP



class MainAction: AnyObject {
    static let _album_prefix = "Album_"
    static let _ALBUM_LIST = "ALBUM_LIST"
    static var _aList:NSMutableArray?
    static var _tempAlbum:NSMutableDictionary?
    
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
    
    //--------登陆用户信息
    
    static var _userId:String!{
        get{
            return "000000"
        }
    }
    static var _currentUser:NSDictionary{
        get{
            return NSDictionary(objects: ["000000","我是我自己"], forKeys: ["userId","userName"])
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
    //----添加图片到相册
    static func _insertPicsToAlbumById(__pics:NSArray,__albumIndex:Int){
        var _images:NSMutableArray = NSMutableArray(array: _getImagesOfAlbumIndex(__albumIndex)!)
        _images.addObjectsFromArray(__pics as [AnyObject])        
        _changeAlbumAtIndex(__albumIndex,dict:NSDictionary(object: _images, forKey: "images"))
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
    static func _saveTempAlbum(dict:NSDictionary){
        _tempAlbum = NSMutableDictionary(dictionary: dict)
    }
    static func _getAlbumAtIndex(index:Int)->NSDictionary?{
        var _albumDict:NSMutableDictionary = NSMutableDictionary(dictionary: MainAction._albumList.objectAtIndex(index) as! NSDictionary)
        _setDefault(_albumDict)
        return _albumDict
    }
    
    
    
    
    
    //-----设置相册默认值
    static func _setDefault(_album:NSMutableDictionary){
        
        if _album.objectForKey("title") == nil{
            _album.setObject("", forKey: "title")
        }
        if _album.objectForKey("cover") == nil{
            _album.setObject(NSDictionary(), forKey: "cover")
        }
        if _album.objectForKey("description") == nil{
            _album.setObject("", forKey: "description")
        }
        if _album.objectForKey("tags") == nil{
            _album.setObject([], forKey: "tags")
        }
        if _album.objectForKey("range") == nil{
            _album.setObject(0, forKey: "range")
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
        var _list:NSMutableArray=NSMutableArray(array:_albumList )
        //println(index)
        _list.removeObjectAtIndex(index)
        _albumList=_list
    }
    static func _getCoverFromAlbumAtIndex(index:Int)->NSDictionary?{
        var _album:NSMutableDictionary = NSMutableDictionary(dictionary: _getAlbumAtIndex(index)!)        
        _setDefault(_album)
        var _images:NSArray = _album.objectForKey("images") as! NSArray
        if _images.count<1{
            return nil
        }
        
        //println(_album.objectForKey("cover"))
        
        var _cover:NSDictionary = _album.objectForKey("cover") as! NSDictionary
        
        
        
        if _albumHasPic(index,__pic: _cover){
            return _cover
        }
        
        if _album.objectForKey("range") != nil && _album.objectForKey("range") as! Int == 0{
            return _images.objectAtIndex(0) as? NSDictionary
        }else{
            return _images.objectAtIndex(_images.count-1) as? NSDictionary
        }
        
    }
    //----检测相册里是否有某张照片
    static func _albumHasPic(__albumIndex:Int,__pic:NSDictionary)->Bool{
        var _album:NSDictionary = _getAlbumAtIndex(__albumIndex)!
        if __pic.objectForKey("url") != nil{
            
        }else{
            return false
        }
        var _images:NSArray = _album.objectForKey("images") as! NSArray
        for var i:Int = 0 ; i<_images.count ;++i{
            if (_images.objectAtIndex(i) as! NSDictionary).objectForKey("url") as! String == __pic.objectForKey("url") as! String{
                return true
            }
        }
        return false
    }
    static func _changeAlbumAtIndex(index:Int,dict:NSDictionary){
        
        
        
        
        var _list:NSMutableArray=NSMutableArray(array:_albumList )
        var _album:NSMutableDictionary=NSMutableDictionary(dictionary: _list.objectAtIndex(index) as! NSDictionary)
        
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
    //------修改相册里的某张图片
    static func _changePicAtAlbum(index:Int,albumIndex:Int,dict:NSDictionary){
        
        var _album:NSDictionary = MainAction._getAlbumAtIndex(albumIndex)!
        
        
        
        var _images:NSMutableArray = NSMutableArray(array: _album.objectForKey("images") as! NSArray)
        
        var _img:NSMutableDictionary = NSMutableDictionary(dictionary: _images.objectAtIndex(index) as! NSDictionary)
        
        for (key,value) in dict{
            //println(key,value)
            _img.setObject(value, forKey: key as! String)
        }
        
        _images[index] = _img
        
        _changeAlbumAtIndex(albumIndex, dict: NSDictionary(object: _images, forKey: "images"))
        
    }
    
    
    
    
    
    
    
    
    //=========================社交部分
    
    //---------提取用户信息
    static func _getUserProfileAtId(userId:String) -> NSDictionary{
        var _dict:NSMutableDictionary = NSMutableDictionary()
        var _pic:NSDictionary =  NSDictionary(objects: ["file","1.png"], forKeys: ["type","url"])
        
        
        _dict.setObject(_pic, forKey: "profileImg")
        _dict.setObject("123456", forKey: "userId")
        _dict.setObject("我就是我", forKey: "userName")
        _dict.setObject(12, forKey: "followedNumber")
        _dict.setObject(30, forKey: "followingNumber")
        _dict.setObject("速度的山高水低是德国大使馆收到根深蒂固三等功时代根深蒂固的是山高水低公司的收到根深蒂固山东省共商国是的根深蒂固", forKey: "sign")
        
        return _dict
    }
    //-----提取某个相册评论－－－－－－//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－过渡方法
    static func _getCommentsOfAlubm(__albumId:String?,block:(NSArray)->Void){
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = __albumId!.toInt()!
        if _n < 1{
            _n = 1
        }
        for var i:Int = 0; i<_n;++i{
            var _comment:String = "受到各国大使馆的是"
            var _commentDict:NSMutableDictionary = NSMutableDictionary(objects: ["某某<"+__albumId!+">","<来"+__albumId!+"来>","111111","123456",_comment], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment"])
            
            if i==0{
                _commentDict.setValue("受到各国的是德国大使馆多少广东省各地说过多少多少多少给多", forKey: "comment")
                _commentDict.setValue("", forKey: "to_userName")
            }
            
            let _pic:NSDictionary = NSDictionary(objects: [String(i%6+1)+".png","file"], forKeys: ["url","type"])
            _commentDict.setValue(_pic, forKey: "userImg")
            
            _array.addObject(_commentDict)
            
        }
        // println(response.text)
        block(_array)
    }
    static func _getLikesOfAlubm(__albumId:String?,block:(NSArray)->Void){
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = __albumId!.toInt()!
        if _n < 1{
            _n = 1
        }
        for var i:Int = 0; i<2*_n;++i{
            
            
            var _dict:NSMutableDictionary
            if i==1||i==5||i==6{
                _dict = NSMutableDictionary(objects: ["t("+String(i)+")","111111"], forKeys: ["userName","userId"])
            }else{
                _dict = NSMutableDictionary(objects: ["ta号是*&("+String(i)+")","111111"], forKeys: ["userName","userId"])
            }
           
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //----提交赞
    static func _postLike(__dict:NSDictionary){
        
    }
    
    
    
    
    
    
    static func _getAlbumListAtUser(block:(NSArray)->Void){
        var request = HTTPTask()
        
        request.GET("http://www.baidu.com", parameters: nil, completionHandler: { (response) -> Void in
            
            block(self._albumList)
        })
        
    }
    
    
}











////////////////////////////－－－－－－－字典变量保存
/*

UserProfileDict:

profileImg<PicDict>  userId userName followedNumber followingNumber sign

PicDict:
type(alasset\fromWeb\file)  url



*/
////


class PicObj:AnyObject {
    var type:String=String()
    var thumbImage:String=String()
    var originalImage:String=String()
    var refreshed:Bool=false
    var pid:String=String()
    var url:String=String()
    
    //  type: alasset fromWeb file
    // url
    
    func _toDict()->NSDictionary{
        return NSDictionary(objects: [thumbImage,originalImage,refreshed,pid,url], forKeys: ["thumbImage","originalImage","refreshed","pid","url"])
    }
}