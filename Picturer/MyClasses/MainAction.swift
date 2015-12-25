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
    
    
    
    
    static let _color_white_title:UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)//----标题白色
    
    static let _color_yellow:UIColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)//----黄色
    static let _color_yellow_bar:UIColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)//----下导航条黄色
    static let _color_black_bar:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.98)//----黑色导航条
    
    static let _color_black_bottom:UIColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)//----底部按钮背景黑
    static let _color_black_title:UIColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)//----黑色标题
    static let _color_gray_subTitle:UIColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)//----灰色副标题标题
    static let _color_gray_time:UIColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)//----时间灰色
    static let _color_gray_description:UIColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)//----描述性文字灰色
    
    
    //-----Font Names = [["PingFangSC-Ultralight", "PingFangSC-Regular", "PingFangSC-Semibold", "PingFangSC-Thin", "PingFangSC-Light", "PingFangSC-Medium"]]
    
    
    static let _font_cell_title:UIFont = UIFont(name: "PingFangSC-Regular", size: 17)! //UIFont.systemFontOfSize(17, weight: 0)//---首页相册条标题字体
    static let _font_cell_title_normal:UIFont = UIFont(name: "PingFangSC-Regular", size: 16)!//UIFont.systemFontOfSize(16, weight: 0)//---一般的cell标题字体
    
    static let _font_cell_subTitle:UIFont = UIFont(name: "PingFangSC-Regular", size: 14)!// UIFont.systemFontOfSize(14, weight: 0)//---首页相册条副标题字体
    static let _font_cell_time:UIFont = UIFont(name: "PingFangSC-Regular", size: 12)!// UIFont.systemFontOfSize(12, weight: 0)//---首页相册条时间字体
    static let _font_topbarTitle:UIFont = UIFont(name: "PingFangSC-Medium", size: 17)!// UIFont.systemFontOfSize(17, weight: 1)//----标题字体
    static let _font_topbarTitle_at_one_pic:UIFont = UIFont(name: "PingFangSC-Medium", size: 15)!//----图片详情标题字体
    static let _font_topButton:UIFont = UIFont(name: "PingFangSC-Medium", size: 16)!//UIFont.systemFontOfSize(16, weight: 1)//----导航条按钮标题
    static let _font_input:UIFont = UIFont(name: "PingFangSC-Regular", size: 15)!//UIFont.systemFontOfSize(15, weight: 0)//----输入字体
    
    static let _font_description_at_bottom:UIFont = UIFont(name: "PingFangSC-Light", size: 14)!//----单张图片底部描述字体
    
    static let _barH:CGFloat = 64
    static let _gap:CGFloat = 15
    static let _gap_2:CGFloat = 11
    
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
               // print(ablums)
                for var i:Int = 0; i < ablums.count; ++i{
                    let _album = ablums.objectAtIndex(i) as! NSDictionary
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
                    print("相册\(__albumId)里的图片：",images)
                    _refreshImagesOfAlbumByIndex(images, __albumIndex: _index)
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

            
            if _pic.objectForKey("_id") == nil{
                _pic.setObject("", forKey: "_id")
            }
            if _pic.objectForKey("last_update_at") == nil{
                _pic.setObject(CoreAction._timeStrOfCurrent(), forKey: "last_update_at")
            }
            if _pic.objectForKey("title") == nil{
                _pic.setObject("", forKey: "title")
            }
            if _pic.objectForKey("create_at") == nil{
                _pic.setObject(CoreAction._timeStrOfCurrent(), forKey: "create_at")
            }
            
            let _localId:String=String(Int(NSDate().timeIntervalSince1970))
            _pic.setObject(_localId, forKey: "localId")
            
            if let _albumId = _album.objectForKey("_id") as? String{
                _pic.setObject(_albumId, forKey: "albumId")//---------已经有在线相册id的用在线相册id保存关联
            }else{
                let _localAbumId:String = _album.objectForKey("localId") as! String
                _pic.setObject(_localAbumId, forKey: "localAbumId")//-------没有在线相册id用本地相册id关联
            }
            print(_pic)
            
            SyncAction._addAction(SyncAction._Type_uploadPic, __content: _pic)
            
            _images.insertObject(_pic, atIndex: 0)
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
                if _image.objectForKey("_id") as! String == _pic.objectForKey("_id")  as! String{
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
            if !_has{
                _images.insertObject(_pic, atIndex: 0)
            }
            
        }
        _changeAlbumAtIndex(__albumIndex,dict:NSDictionary(object: _images, forKey: "images"))
    }
    
    //----新建相册
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
        
        //------如果是来自本地命令
        if _album.objectForKey("_id") as! String == ""{
            SyncAction._addAction(SyncAction._Type_newAlbum, __content: _album)
        }
        
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
        if _album.objectForKey("description") == nil{
            _album.setObject("", forKey: "description")
        }
        if _album.objectForKey("tags") == nil{
            _album.setObject([], forKey: "tags")
        }
        if _album.objectForKey("range") == nil{//-------默认1，倒序
            _album.setObject(1, forKey: "range")
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
        _deleteAlbumFromServer(_dict)
        
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
        if _album.objectForKey("range") != nil && _album.objectForKey("range") as! Int == 0{
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
    
    
    //------提交更新相册信息，除了所有的图片
    
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
        }
        if let _albumId = _album.objectForKey("_id") as? String{
            SyncAction._addAction(SyncAction._Type_updateAlbum, __content: NSDictionary(objects: [_albumId,_str], forKeys: ["_id","changeingStr"]))
        }
        _changeAlbumAtIndex(index, dict: _dict)
    }
    //------修改相册里的某张图片
    static func _changePicAtAlbum(index:Int,albumIndex:Int,dict:NSDictionary){
        let _album:NSDictionary = MainAction._getAlbumAtIndex(albumIndex)!
        let _images:NSMutableArray = NSMutableArray(array: _album.objectForKey("images") as! NSArray)
        let _img:NSMutableDictionary = NSMutableDictionary(dictionary: _images.objectAtIndex(index) as! NSDictionary)
        for (key,value) in dict{
            //println(key,value)
            _img.setObject(value, forKey: key as! String)
        }
        _images[index] = _img
        _changeAlbumAtIndex(albumIndex, dict: NSDictionary(object: _images, forKey: "images"))
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
    
    //=========================社交部分
    
    //--------登陆用户信息
    
    static var _userId:String!{
        get{
            return "000000"
        }
    }
    static var _currentUser:NSDictionary{
        get{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            let _pic:NSDictionary =  NSDictionary(objects: ["file","user_1.jpg"], forKeys: ["type","url"])
            _dict.setObject(_pic, forKey: "profileImg")
            _dict.setObject("000000", forKey: "userId")
            _dict.setObject("小小白", forKey: "userName")
            _dict.setObject(66, forKey: "albumNumber")
            _dict.setObject(12, forKey: "followNumber")
            _dict.setObject(30, forKey: "followingNumber")
            _dict.setObject("浪漫的实用主义  WeChat:tianlu_3213", forKey: "sign")
            return _dict
        }
    }
    //-----获取主页提示信息
    static func _getAlertsOfSocial(__block:(NSArray)->Void){
        let array:NSMutableArray = NSMutableArray()
        array.addObject(NSDictionary(objects: [1,NSDictionary(objects: ["user_11.jpg","file"], forKeys: ["url","type"])], forKeys: ["num","pic"]))
        array.addObject(NSDictionary(objects: [-1,NSDictionary(objects: ["user_8.jpg","file"], forKeys: ["url","type"])], forKeys: ["num","pic"]))
        array.addObject(NSDictionary(objects: [0,NSDictionary(objects: ["1.png","file"], forKeys: ["url","type"])], forKeys: ["num","pic"]))
        array.addObject(NSDictionary(objects: [0,NSDictionary(objects: ["1.png","file"], forKeys: ["url","type"])], forKeys: ["num","pic"]))
        array.addObject(NSDictionary(objects: [0,NSDictionary(objects: ["1.png","file"], forKeys: ["url","type"])], forKeys: ["num","pic"]))
        array.addObject(NSDictionary(objects: [0,NSDictionary(objects: ["1.png","file"], forKeys: ["url","type"])], forKeys: ["num","pic"]))
        array.addObject(NSDictionary(objects: [0,NSDictionary(objects: ["1.png","file"], forKeys: ["url","type"])], forKeys: ["num","pic"]))
        __block(array)
    }
    //----------相册图片列表
    
    //---------提取用户信息
    static func _getUserProfileAtId(userId:String) -> NSDictionary{
        if userId == _userId{
            return _currentUser
        }
        let _dict:NSMutableDictionary = NSMutableDictionary()
        let _pic:NSDictionary =  NSDictionary(objects: ["file","user_1.jpg"], forKeys: ["type","url"])
        
        
        _dict.setObject(_pic, forKey: "profileImg")
        
        
        _dict.setObject("123456", forKey: "userId")
        _dict.setObject("Alex", forKey: "userName")
        
        _dict.setObject(13, forKey: "albumNumber")
        
        _dict.setObject(2, forKey: "followNumber")
        _dict.setObject(5, forKey: "followingNumber")
        _dict.setObject("世上乐队千千万，出色的音乐只是获得成功的条件之一", forKey: "sign")
        
        return _dict
    }
    //-------
    
    //------消息列表
    static func _getMessages(block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 1
        for var i:Int = 0; i<_n;++i{
            let _comment:String = _testComments?.objectAtIndex(random()%31) as! String
            let _commentDict:NSMutableDictionary = NSMutableDictionary(objects: [_testUserNames?.objectAtIndex(random()%31) as! String,_testComments?.objectAtIndex(random()%31) as! String,"111111","123456",_comment,"下午1:00","comment","333333"], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","time","type","albumId"])
            
            if i==0||i==5||i==6{
                _commentDict.setValue("好喜欢这个哈", forKey: "comment")
                _commentDict.setValue("", forKey: "to_userName")
                _commentDict.setValue("", forKey: "to_userId")
            }
            
            if i==3||i==10||i==29||i==20{
                _commentDict.setValue("like", forKey: "type")
            }
            if i==12{
                _commentDict.setValue("collect", forKey: "type")
            }
            
            let _pic:NSDictionary = NSDictionary(objects: ["user_11.jpg","file"], forKeys: ["url","type"])
            _commentDict.setValue(_pic, forKey: "userImg")
            
            let _albumPic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%6+1)+".JPG","file"], forKeys: ["url","type"])
            _commentDict.setValue(_albumPic, forKey: "albumImg")
            
            _array.addObject(_commentDict)
            
        }
        // println(response.text)
        block(_array)
    }
    //-----提取某个相册评论－－－－－－//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－过渡方法
    static func _getCommentsOfAlubm(__albumId:String?,block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        var _n:Int = Int(__albumId!)!
        if _n < 1{
            _n = 1
        }
        if _n < 4{
            block(_array)
            return
        }
        //_n = 0
        for var i:Int = 0; i <= (_n-1);++i{
            let _comment:String = _testComments?.objectAtIndex(random()%31) as! String
            let _commentDict:NSMutableDictionary = NSMutableDictionary(objects: [_testUserNames?.objectAtIndex(random()%31) as! String,_testToUserNames?.objectAtIndex(i) as! String,"111111","123456",_comment,"15-10-9"], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","time"])
//            if i==0{
//                _commentDict.setValue("", forKey: "comment")
//                _commentDict.setValue("", forKey: "to_userName")
//                _commentDict.setValue("", forKey: "to_userId")
//            }
            
            let _pic:NSDictionary = NSDictionary(objects: ["user_"+String(i%6+1)+".jpg","file"], forKeys: ["url","type"])
            _commentDict.setValue(_pic, forKey: "userImg")
            
            _array.addObject(_commentDict)
            
        }
        // println(response.text)
        block(_array)
    }
    static func _getLikesOfAlubm(__albumId:String?,block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        var _n:Int = Int(__albumId!)!
        if _n < 1{
            _n = 1
        }
        for var i:Int = 0; i < (_n-1);++i{
            var _dict:NSMutableDictionary
            if i==1||i==5||i==6{
                _dict = NSMutableDictionary(objects: [_testUserNames!.objectAtIndex(random()%31) as! String,"111111"], forKeys: ["userName","userId"])
            }else{
                _dict = NSMutableDictionary(objects: [_testUserNames!.objectAtIndex(random()%31) as! String,"111111"], forKeys: ["userName","userId"])
            }
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //----提交赞
    static func _postLike(__dict:NSDictionary){
        
    }
    //-----提取相册里的所有图片
    static func _getPicsListAtAlbumId(__albumId:String?,block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 28
        
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            
            let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%8+1)+".JPG","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject(i, forKey: "likeNumber")
            _dict.setObject(i*3, forKey: "commentNumber")
            
            if i%5==0{
                _dict.setObject("跟我鞥上的恐怕个品位女士订购扫和光缆的那个啊山东省的那个三等功上度过呢哦你感动啊就是大户个阿萨德个", forKey: "description")
            }else{
                _dict.setObject("旦各国那份的歌噶蛋糕给我挥洒地方", forKey: "description")
            }
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //-----获取相册里的所有图片＊＊＊＊暂时用本地信息替代在线信息
    static func _getPicsListAt(albumIndex:Int,block:(NSArray)->Void){
        let _theA:NSArray = MainAction._getImagesOfAlbumIndex(albumIndex)!
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = _theA.count
        let _range:Int = (_albumList.objectAtIndex(albumIndex) as! NSDictionary).objectForKey("range") as! Int
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            
            let _pic:NSDictionary = _theA.objectAtIndex(i) as! NSDictionary
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject(i, forKey: "likeNumber")
            _dict.setObject(i*3, forKey: "commentNumber")
            
            if ((_theA.objectAtIndex(i) as! NSDictionary).objectForKey("description") != nil){
                _dict.setObject((_theA.objectAtIndex(i) as! NSDictionary).objectForKey("description") as! String, forKey: "description")
            }else{
                _dict.setObject("跟我和光缆的那个啊山东省的那个三等功上度过呢哦你感动啊就是大户个阿萨德个", forKey: "description")
            }
            
            if  _range == 0{
                _array.addObject(_dict)
            }else{
                _array.insertObject(_dict, atIndex: 0)
            }
        }
         
        block(_array)
    }
    static func _getLikesOfPicId(__picId:String){
        
    }
    static func _getCommentsOfPicId(__picId:String){
        
    }
    //-----提取热门图册
    static func _getHotAlbums(block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 10
        
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%6+2)+".JPG","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject("000001", forKey: "albumId")
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //------提取热门用户
    static func _getHotUsers(block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 10
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            
            var _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%5+3)+".JPG","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _pic = NSDictionary(objects: ["user_"+String(i%6+1)+".jpg","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "userImg")
            _dict.setObject("000001", forKey: "userId")
            _dict.setObject(_testUserNames?.objectAtIndex(random()%31) as! String, forKey: "userName")
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //-----提取推荐相册
    static func _getReferenceAlbums(block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 10
        
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            
            let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%4+3)+".JPG","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject("000001", forKey: "albumId")
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    
    //----最近搜索标签
    
    static func _getRecentSearchTags()->NSArray{
        return ["紫砂","跑步","香格里拉","今年流行款"]
    }
    //-----推荐搜索标签
    static func _getReferenceTags(block:(NSArray)->Void){
        let _array:NSArray = ["旅行","健身","艺术","摄影","电影","美食","成长","设计","时尚","魔兽","春天","行为艺术"]
        block(_array)
    }
    //-----搜索结果－－－相册
    static func _getResultOfAlbum(__searchingStr:String, block:(NSArray)->Void){
       let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 40
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%4+3)+".JPG","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject("000001", forKey: "albumId")
            _array.addObject(_dict)
        }
        block(_array)
    }
    //搜索结果－－－－用户
    static func _getResultOfUser(__searchingStr:String, block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 40
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%5+3)+".JPG","file"], forKeys: ["url","type"])
            //_dict.setObject(_pic, forKey: "pic")
            //_pic = NSDictionary(objects: [String(i%6+1)+".png","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "userImg")
            _dict.setObject("000001", forKey: "userId")
            
            if i==1||i==3||i==5{
                _dict.setObject("", forKey: "sign")
            }else{
                _dict.setObject("我不要跟随", forKey: "sign")
            }
            
            _dict.setObject(_testUserNames?.objectAtIndex(random()%31) as! String, forKey: "userName")
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //-------获取主页图册列表＊＊当用户是本人，提取本地
    static func _getAlbumListAtUser(__userId:String,block:(NSArray)->Void){
//        var request = HTTPTask()
//        request.GET("http://www.baidu.com", parameters: nil, completionHandler: { (response) -> Void in
//            block(self._albumList)
//        })
        
        if __userId == _userId{
            let _array:NSMutableArray = NSMutableArray(array: _albumList)
            let _n:Int = _array.count
            for var i:Int = 0; i<_n;++i{
                let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _array.objectAtIndex(i) as! NSDictionary)
                
                let _pic:NSDictionary = _getCoverFromAlbumAtIndex(i)!
                _dict.setObject(_pic, forKey: "cover")
                _array[i] = _dict
            }
            block(_array)
            return
        }else{
            let _array:NSMutableArray = NSMutableArray()
            let _n:Int = 10
            for var i:Int = 0; i<_n;++i{
                let _dict:NSMutableDictionary = NSMutableDictionary()
                let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%4+3)+".JPG","file"], forKeys: ["url","type"])
                _dict.setObject(_pic, forKey: "cover")
                _dict.setObject("天边一朵云", forKey: "title")
                _dict.setObject("个人欣赏", forKey: "description")
                _array.addObject(_dict)
            }
            block(_array)
            
        }
        
    }
    //－－－－提取朋友更新图册列表
    static func _getFriendsNewsList(block:(NSArray)->Void){
            let _array:NSMutableArray = NSMutableArray()
            let _n:Int = 10
            for var i:Int = 0; i<_n;++i{
                let _dict:NSMutableDictionary = NSMutableDictionary()
                
                let _pics:NSMutableArray = NSMutableArray()
                
                var _num:Int = i
                if _num>8{
                    _num = 8
                }
                
                for t in 0..._num{
                    let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String((t+i)%6+3)+".JPG","file"], forKeys: ["url","type"])
                    _pics.addObject(_pic)
                }
                _dict.setObject(_pics, forKey: "pics")
                
                let _pic:NSDictionary = NSDictionary(objects: ["user_"+String(i%10+2)+".jpg","file"], forKeys: ["url","type"])
                _dict.setObject(_pic, forKey: "userImg")
                _dict.setObject(_testUserNames?.objectAtIndex(random()%31) as! String, forKey: "userName")
                _dict.setObject("000002", forKey: "userId")
                _dict.setObject("天边一朵云", forKey: "title")
                _dict.setObject("个人欣赏", forKey: "description")
                _array.addObject(_dict)
            }
            block(_array)
    }
    //－－－－提取妙人更新图册列表
    static func _getLikesNewsList(block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 10
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            let _pics:NSMutableArray = NSMutableArray()
            var _num:Int = i+5
            if _num>8{
                _num = 8
            }
            for t in 0..._num{
                let _pic:NSDictionary = NSDictionary(objects: ["pic_"+String((t+i)%5+4)+".JPG","file"], forKeys: ["url","type"])
                _pics.addObject(_pic)
            }
            _dict.setObject(_pics, forKey: "pics")
            
            let _pic:NSDictionary = NSDictionary(objects: ["user_"+String(i%8+1)+".jpg","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "userImg")
            _dict.setObject(_testUserNames?.objectAtIndex(random()%31) as! String, forKey: "userName")
            _dict.setObject("000002", forKey: "userId")
            _dict.setObject("天边一朵云", forKey: "title")
            _dict.setObject("个人欣赏", forKey: "description")
            _array.addObject(_dict)
        }
        block(_array)
    }
    //－－－－提取收藏图册列表
    static func _getCollectList(block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 10
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            var _pic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%8+1)+".JPG","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "cover")
            
            _pic = NSDictionary(objects: ["pic_"+String(i%4+3)+".JPG","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "userImg")
            _dict.setObject(_testUserNames?.objectAtIndex(random()%31) as! String, forKey: "userName")
            _dict.setObject("天边一朵云", forKey: "title")
            _dict.setObject(_testDes?.objectAtIndex(random()%_testDes!.count) as! String, forKey: "description")
            _array.addObject(_dict)
        }
        block(_array)
    }
    static func _getAdvertisiongs(block:(NSArray)->Void){
    
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 4
        
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary()
            
            let _pic:NSDictionary = NSDictionary(objects: ["ad_"+String(i%5+1)+".jpg","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject("http://baidu.com", forKey: "link")
           
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    
    
}



var _testUserNames:NSArray? = ["Anna","小甜菜","大漠之狐","蛋蛋的忧桑","李明","Alex","和尚","Leo.Lee","李萌","文华项","注目2度","天涯1刀","过岸雁","Gary","白云工作室","摄影师刘亮","诸明","百搭小姐","匆匆走来，慢慢走掉","中间人","李爱爱","王得力","摩擦摩擦","拉拉轰","歌手毛利利","Nora","Miguel","Miller","Martin","熊猫","Amy","王德礼"]

var _testToUserNames:NSArray? = ["Liam","无理取闹","红云","映射人像摄影","行走在大街上","魅力王晓","走着","飞行的枕头","Lee Lord","双人鱼","鸡皮小崽子","那是胖纸 ","JOE","镜中的脸孔","御风の小白","七个名字","孤独的长跑者","張傑偉","椰芮","安雨","长腿林美宝","深信不疑","Fear","庸人自扰","逆水行舟","雨中日光","雄熊","塞林顿","青春痕迹","三文鱼好吃。","不去会死","北派三叔","你们真会玩"]

var _testComments:NSArray?=["拍的不错","你去哪了","又玩去了吗？","明天次饭走起啊","好闲啊你","我喜欢这样的感觉","很有feel的一组照片哈","怎么拍出来","这是什么","你什么时候去的？","哈哈哈哈","赞啊","100个赞","城里人真会玩","果然厉害","挺流弊的样子",":)",":p","lol"," Great","good jog","牛逼","你说的对","还是你了解我","太棒了","这个调调不错","我也觉得这个不错","wow～","厉害！！！","挺厉害的！","喜欢，😍","赞赞赞","哇！！","真不错"]

var _testDes:NSArray?=["小隐隐于山，大隐隐于市","向往宁静的生活，不过分的追名逐利。生活安详自得便好","一杯清茶泡禅意","淡淡的是一种意境，归隐是一种安逸。","喜欢这样淡淡的生活，喜欢这样的中庸。","别说我没有志气，我就是这样。","一人独钓一江水","这个是一个宣泄的地方，把孤单留在这里","用微笑去面对所有。","我不是佛，我做不到永远微笑，但是我会在背后默默的流泪。","一座城一生心疼","那些曾经让我感动，甚至现在还让我感动着的人们","带给我力量，给过我支持，尽管是虚拟的世界里","一些人一生追随","我爱的小哀,你执著的是什么？","那不是你的意愿，不是你的错啊…为什么要这样对你？","心疼你…如果能保护你","一颗心哀之永恒","也许风景哪里都好，那里的风景永远是最美的","一座城一生挂念","一个人走过的风风雨雨，","那个谁说的，一个人的旅行或许不叫旅行，叫流浪吧","那么，虽然我没有去过很多地方，但是，一个也曾去流浪了一些地方","浪迹天涯独自走","这些曾经或现在，出现在我生命中的人（还有未有照片的）","现在以及以后，或许在，或许不在","谢谢，你们给予我的那些温暖。","值得铭记的温暖"]

////////////////////////////－－－－－－－字典变量索引
/*

UserProfileDict:

profileImg<PicDict>  userId userName followNumber followingNumber sign


Message

"from_userName","to_userName","from_userId","to_userId","comment","type","userImg","albumImg"

type(like\comment\collect)

PicDict:
type(alasset\fromWeb\file)  url

PicOfAlbum 相册里的图片

pic<PicDict> likeNumber commentNumber description



*/
////

