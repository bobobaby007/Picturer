//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
//import SwiftHTTP



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
    
    //--------登陆用户信息
    
    static var _userId:String!{
        get{
            return "000000"
        }
    }
    static var _currentUser:NSDictionary{
        get{
            
            
            var _dict:NSMutableDictionary = NSMutableDictionary()
            var _pic:NSDictionary =  NSDictionary(objects: ["file","1.png"], forKeys: ["type","url"])
            
            
            _dict.setObject(_pic, forKey: "profileImg")
            
            
            _dict.setObject("000000", forKey: "userId")
            _dict.setObject("小小白", forKey: "userName")
            
            _dict.setObject(66, forKey: "albumNumber")
            _dict.setObject(12, forKey: "followNumber")
            _dict.setObject(30, forKey: "followingNumber")
            _dict.setObject("文革那份多少粉丝三等功", forKey: "sign")
            
            
            return _dict
        }
    }
    
    //----------相册图片列表
    
    
    
    //---------提取用户信息
    static func _getUserProfileAtId(userId:String) -> NSDictionary{
        if userId == _userId{
            return _currentUser
        }
        var _dict:NSMutableDictionary = NSMutableDictionary()
        var _pic:NSDictionary =  NSDictionary(objects: ["file","1.png"], forKeys: ["type","url"])
        
        
        _dict.setObject(_pic, forKey: "profileImg")
        
        
        _dict.setObject("123456", forKey: "userId")
        _dict.setObject("其他用户", forKey: "userName")
        
        _dict.setObject(13, forKey: "albumNumber")
        
        _dict.setObject(2, forKey: "followNumber")
        _dict.setObject(5, forKey: "followingNumber")
        _dict.setObject("速度的山高水低是德国大使馆收到根深蒂固三等功时代根深蒂固的的根深蒂固", forKey: "sign")
        
        return _dict
    }
    //-------
    
    //------消息列表
    static func _getMessages(block:(NSArray)->Void){
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 30
        for var i:Int = 0; i<_n;++i{
            var _comment:String = "受到各国大使馆的是"
            var _commentDict:NSMutableDictionary = NSMutableDictionary(objects: ["某某<"+String(i)+">","<来"+String(i)+"来>","111111","123456",_comment,"下午1:00","comment","333333"], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","time","type","albumId"])
            
            if i==0||i==5||i==6{
                _commentDict.setValue("受到各国的是德国大使馆多少广东省各地说过多少多少多少给多", forKey: "comment")
                _commentDict.setValue("", forKey: "to_userName")
                _commentDict.setValue("", forKey: "to_userId")
            }
            
            if i==3||i==10||i==29||i==20{
                _commentDict.setValue("like", forKey: "type")
            }
            if i==12{
                _commentDict.setValue("collect", forKey: "type")
            }
            
            let _pic:NSDictionary = NSDictionary(objects: [String(i%5+2)+".png","file"], forKeys: ["url","type"])
            _commentDict.setValue(_pic, forKey: "userImg")
            
            let _albumPic:NSDictionary = NSDictionary(objects: [String(i%6+1)+".png","file"], forKeys: ["url","type"])
            _commentDict.setValue(_albumPic, forKey: "albumImg")
            
            
            
            _array.addObject(_commentDict)
            
        }
        // println(response.text)
        block(_array)
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
            var _commentDict:NSMutableDictionary = NSMutableDictionary(objects: ["某某<"+__albumId!+">","<来"+__albumId!+"来>","111111","123456",_comment,"15-10-9"], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","time"])
            
            if i==0{
                _commentDict.setValue("受到各国的是德国大使馆多少广东省各地说过多少多少多少给多", forKey: "comment")
                _commentDict.setValue("", forKey: "to_userName")
                _commentDict.setValue("", forKey: "to_userId")
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
    
    //-----提取相册里的所有图片
    static func _getPicsListAtAlbumId(__albumId:String?,block:(NSArray)->Void){
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 28
        
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            
            let _pic:NSDictionary = NSDictionary(objects: [_testPics?.objectAtIndex(i%8) as! String,"fromWeb"], forKeys: ["url","type"])
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
        
        var _theA:NSArray = MainAction._getImagesOfAlbumIndex(albumIndex)!
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = _theA.count
        var _range:Int = (_albumList.objectAtIndex(albumIndex) as! NSDictionary).objectForKey("range") as! Int
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            
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
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 10
        
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            let _pic:NSDictionary = NSDictionary(objects: [_testPics?.objectAtIndex(i%6+2) as! String,"fromWeb"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject("000001", forKey: "albumId")
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    
    //------提取热门用户
    static func _getHotUsers(block:(NSArray)->Void){
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 10
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            
            var _pic:NSDictionary = NSDictionary(objects: [_testPics?.objectAtIndex(i%5+3) as! String,"fromWeb"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _pic = NSDictionary(objects: [String(i%6+1)+".png","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "userImg")
            _dict.setObject("000001", forKey: "userId")
            _dict.setObject(_testUserNames?.objectAtIndex(i%12) as! String, forKey: "userName")
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //-----提取推荐相册
    static func _getReferenceAlbums(block:(NSArray)->Void){
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 10
        
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            
            let _pic:NSDictionary = NSDictionary(objects: [_testPics?.objectAtIndex(i%4+3) as! String,"fromWeb"], forKeys: ["url","type"])
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
        var _array:NSArray = ["旅行","健身","艺术","摄影","电影","美食","成长","设计","时尚","魔兽","春天","行为艺术"]
        block(_array)
    }
    //-----搜索结果－－－相册
    static func _getResultOfAlbum(__searchingStr:String, block:(NSArray)->Void){
       var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 40
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            let _pic:NSDictionary = NSDictionary(objects: [_testPics?.objectAtIndex(i%4+3) as! String,"fromWeb"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject("000001", forKey: "albumId")
            _array.addObject(_dict)
        }
        block(_array)
    }
    //搜索结果－－－－用户
    static func _getResultOfUser(__searchingStr:String, block:(NSArray)->Void){
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 40
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            var _pic:NSDictionary = NSDictionary(objects: [_testPics?.objectAtIndex(i%5+3) as! String,"fromWeb"], forKeys: ["url","type"])
            //_dict.setObject(_pic, forKey: "pic")
            //_pic = NSDictionary(objects: [String(i%6+1)+".png","file"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "userImg")
            _dict.setObject("000001", forKey: "userId")
            
            if i==1||i==3||i==5{
                _dict.setObject("", forKey: "sign")
            }else{
                _dict.setObject("我鞥三sg收到各位更冷冻过的时光树大根深等功", forKey: "sign")
            }
            
            _dict.setObject(_testUserNames?.objectAtIndex(i%12) as! String, forKey: "userName")
            
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    //-
    static func _getAlbumListAtUser(__userId:String,block:(NSArray)->Void){
//        var request = HTTPTask()
//        request.GET("http://www.baidu.com", parameters: nil, completionHandler: { (response) -> Void in
//            block(self._albumList)
//        })
        
        if __userId == _userId{
            var _array:NSMutableArray = NSMutableArray(array: _albumList)
            var _n:Int = _array.count
            for var i:Int = 0; i<_n;++i{
                var _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _array.objectAtIndex(i) as! NSDictionary)
                
                let _pic:NSDictionary = _getCoverFromAlbumAtIndex(i)!
                _dict.setObject(_pic, forKey: "cover")
                _array[i] = _dict
            }
            block(_array)
            return
        }else{
            var _array:NSMutableArray = NSMutableArray()
            var _n:Int = 10
            for var i:Int = 0; i<_n;++i{
                var _dict:NSMutableDictionary = NSMutableDictionary()
                let _pic:NSDictionary = NSDictionary(objects: [_testPics?.objectAtIndex(i%4+3) as! String,"fromWeb"], forKeys: ["url","type"])
                _dict.setObject(_pic, forKey: "cover")
                _dict.setObject("天边一朵云", forKey: "title")
                _dict.setObject("个人欣赏", forKey: "description")
                _array.addObject(_dict)
            }
            block(_array)
            
        }
        
    }
    
    static func _getAdvertisiongs(block:(NSArray)->Void){
    
        var _array:NSMutableArray = NSMutableArray()
        var _n:Int = 4
        
        for var i:Int = 0; i<_n;++i{
            var _dict:NSMutableDictionary = NSMutableDictionary()
            
            let _pic:NSDictionary = NSDictionary(objects: [_advertisingPics?.objectAtIndex(i%4) as! String,"fromWeb"], forKeys: ["url","type"])
            _dict.setObject(_pic, forKey: "pic")
            _dict.setObject("http://baidu.com", forKey: "link")
           
            _array.addObject(_dict)
        }
        // println(response.text)
        block(_array)
    }
    
    
}



var _advertisingPics:NSArray? = ["http://b.hiphotos.baidu.com/image/pic/item/0bd162d9f2d3572c1826b51d8813632763d0c32e.jpg","http://f.hiphotos.baidu.com/image/pic/item/ae51f3deb48f8c5471a15c2e38292df5e0fe7f45.jpg","http://e.hiphotos.baidu.com/image/pic/item/a08b87d6277f9e2fab4441021d30e924b899f343.jpg","http://f.hiphotos.baidu.com/image/pic/item/6159252dd42a2834f964801d58b5c9ea14cebfe2.jpg"]

var _testPics:NSArray? = ["http://pic.miercn.com/uploads/allimg/150721/40-150H10U219.jpg","http://e.hiphotos.baidu.com/image/pic/item/42166d224f4a20a4aac7452992529822730ed007.jpg","http://g.hiphotos.baidu.com/image/pic/item/caef76094b36acafd0c0d5fd7ed98d1001e99c8b.jpg","http://b.hiphotos.baidu.com/image/pic/item/d6ca7bcb0a46f21f779e1349f5246b600c33ae06.jpg","http://c.hiphotos.baidu.com/image/pic/item/0dd7912397dda144476ed9afb0b7d0a20cf4864c.jpg","http://pic.miercn.com/uploads/allimg/150721/40-150H10U219.jpg","http://e.hiphotos.baidu.com/image/pic/item/42166d224f4a20a4aac7452992529822730ed007.jpg","http://g.hiphotos.baidu.com/image/pic/item/caef76094b36acafd0c0d5fd7ed98d1001e99c8b.jpg","http://b.hiphotos.baidu.com/image/pic/item/d6ca7bcb0a46f21f779e1349f5246b600c33ae06.jpg","http://c.hiphotos.baidu.com/image/pic/item/0dd7912397dda144476ed9afb0b7d0a20cf4864c.jpg"]


var _testUserNames:NSArray? = ["撒嘎嘎","wong","三等功ww","4ysng----sdgng@as","sdg","跟你说过的","阿里给你的","里那个护送","oeoogaeg","sySYNG2345©˙©∆˚ß","3","fg","人家感到十分娃娃","后排没有拍","94肩负起哦昂","大概","杜省公会"]


////////////////////////////－－－－－－－字典变量保存
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

