//
//  Social_Main.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/7.
//  Copyright © 2016年 4view. All rights reserved.
//


import Foundation
import UIKit

class Social_Main: AnyObject {
    //=========================社交部分
    static let _FRRINDS_LIST:String = "friends_list" //---朋友列表缓存文件名
    static let _FOCUSME_LIST:String = "focusme_list" //---妙人列表缓存文件名
    static let _MESSAGE_LIST:String = "focusme_list" //---消息列表缓存文件名
    
    static var _fList:NSMutableArray?
    static var _fmList:NSMutableArray?
    
    static var _mesList:NSMutableArray?
    
    //--------登陆用户信息
    static var _userId:String!{
        get{
            return MainInterface._uid
        }
    }
    static var _friendList:NSMutableArray!{
        get{
        if _fList==nil{
        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var _list:NSMutableArray?=_ud.valueForKey(_FRRINDS_LIST) as? NSMutableArray
        //println(_list)
        if _list==nil{
        _list = NSMutableArray(array: [])
        _ud.setObject(_list, forKey: _FRRINDS_LIST)
        }
        _fList = _list
        }
        return _fList
        }
        set{
            //println("set")
            _fList=newValue
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            _ud.setObject(_fList, forKey: _FRRINDS_LIST)
            //println(_ud.dictionaryRepresentation())
        }
    }
    static var _focusMeList:NSMutableArray!{
        get{
        if _mesList==nil{
        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var _list:NSMutableArray?=_ud.valueForKey(_MESSAGE_LIST) as? NSMutableArray
        //println(_list)
        if _list==nil{
        _list = NSMutableArray(array: [])
        _ud.setObject(_list, forKey: _MESSAGE_LIST)
        }
        _mesList = _list
        }
        return _mesList
        }
        set{
            //println("set")
            _mesList=newValue
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            _ud.setObject(_mesList, forKey: _MESSAGE_LIST)
            //println(_ud.dictionaryRepresentation())
        }
    }
    
    
    static var _messageList:NSMutableArray!{
        get{
        if _fmList==nil{
        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var _list:NSMutableArray?=_ud.valueForKey(_FOCUSME_LIST) as? NSMutableArray
        //println(_list)
        if _list==nil{
        _list = NSMutableArray(array: [])
        _ud.setObject(_list, forKey: _FOCUSME_LIST)
        }
        _fmList = _list
        }
        return _fmList
        }
        set{
            //println("set")
            _fmList=newValue
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            _ud.setObject(_fmList, forKey: _FOCUSME_LIST)
            //println(_ud.dictionaryRepresentation())
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
    //----获取本地图册列表，未在线更新
    static func _getMyAlbumListLocal(__block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray(array: MainAction._albumList)
        let _n:Int = _array.count
        for var i:Int = 0; i<_n;++i{
            let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _array.objectAtIndex(i) as! NSDictionary)
            
            let _pic:NSDictionary! = MainAction._getCoverFromAlbumAtIndex(i)
            
            if _pic != nil{
                _dict.setObject(_pic, forKey: "cover")
            }else{
                _dict.setObject(NSDictionary(objects: ["no_cover.png","file"], forKeys: ["url","type"]), forKey: "cover")
            }
            
            let _pics:NSArray = MainAction._getImagesOfAlbumIndex(i)!
            _dict.setObject(_pics.count, forKey: "counts")
            
            _array[i] = _dict
        }
        print("本地图册列表：",_array)
        __block(_array)
    }
    //-------获取在线主页图册列表
    static func _getAlbumListAtUser(__userId:String,__block:(NSArray)->Void){
        MainInterface._getAlbumListOfUser(__userId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                let ablums:NSArray = __dict.objectForKey("list") as! [NSDictionary]
                __block(ablums)
            }
        }
    }
    //-----提取相册里的所有图片
    static func _getPicsListAtAlbumId(__albumId:String?,__block:(NSArray)->Void){
        MainInterface._getImagesOfAlbum(__albumId!) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                let images:NSArray = __dict.objectForKey("list") as! [NSDictionary]
                __block(images)
            }else{
                print(__dict.objectForKey("reason"))
            }
        }
    }
    //-----提取相册详情－－－包含5条评论
    static func _getAlbumDetail(__albumId:String?,__block:(NSDictionary)->Void){
        MainInterface._getAlbumDetail(__albumId!) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                
                __block(__dict.objectForKey("albuminfo") as! NSDictionary)
            }
        }
    }
    
    //----评论图片
    static func _commentPic(__id:String,__text:String, __re:String, __block:(NSDictionary)->Void){
        MainInterface._commentPic(__id, __text: __text, __re: __re) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                
            }
        }
    }
    //----获取图片评论和点赞列表
    static func _getPicCommentAndLikes(__id:String, __block:(NSDictionary)->Void){
        MainInterface._getPicCommentAndLikes(__id) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                let _dict:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                let _outDict:NSDictionary = NSDictionary(objects: [_dict.objectForKey("comment") as! NSArray,_dict.objectForKey("like") as! NSArray], forKeys: ["comment","like"])
                __block(_outDict)
            }
        }
    }
    
    //----评论相册
    static func _commentAlbum(__id:String,__text:String, __re:String, __block:(NSDictionary)->Void){
        MainInterface._commentAlbum(__id, __text: __text, __re: __re) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                
            }
        }
    }
    //----获取相册评论和点赞列表
    static func _getAlbumCommentAndLikes(__id:String, __block:(NSDictionary)->Void){
        MainInterface._getAlbumCommentAndLikes(__id) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                let _dict:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                let _outDict:NSDictionary = NSDictionary(objects: [_dict.objectForKey("comment") as! NSArray,_dict.objectForKey("like") as! NSArray], forKeys: ["comment","like"])
                __block(_outDict)
            }
        }
    }
    
    //----评论状态
    static func _commentTimeline(__id:String,__text:String, __re:String, __block:(NSDictionary)->Void){
        MainInterface._commentTimeline(__id, __text: __text, __re: __re) { (__dict) -> Void in
            print(__dict)
            
        }
    }
    //----获取状态评论和点赞列表
    static func _getTimelineCommentAndLikes(__id:String, __block:(NSDictionary)->Void){
        MainInterface._getTimelineCommentAndLikes(__id) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                let _dict:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                let _outDict:NSDictionary = NSDictionary(objects: [_dict.objectForKey("comment") as! NSArray,_dict.objectForKey("like") as! NSArray], forKeys: ["comment","like"])
                __block(_outDict)
            }
        }
    }
    //-----提取我自己的相册里的所有图片－－来自本地
    static func _getImagesOfAlbumIndex(__albumIndex:Int,__block:(NSArray)->Void){
        let _images:NSArray = MainAction._getImagesOfAlbumIndex(__albumIndex)!
        
        return __block(_images)
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
    
    //---------提取用户信息
    static func _getUserProfileAtId(__userId:String,__block:(NSDictionary)->Void){
       MainInterface._getUserInfo(__userId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
              //print("用户信息：",__dict)
                 __block(__dict.objectForKey("userinfo") as! NSDictionary)
            }
            // print("_getUserProfileAtId",__dict)
        }
        
        /*
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
*/
    }
    //----关注用户
    static func _focusToUser(__userId:String,__block:(NSDictionary)->Void){
        MainInterface._focusToUser(__userId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                print("关注用户成功：",__dict)
                //__block(__dict.objectForKey("userinfo") as! NSDictionary)
            }
            // print("_getUserProfileAtId",__dict)
        }
    }
    //----取消关注用户
    static func _cancelFocusToUser(__userId:String,__block:(NSDictionary)->Void){
        MainInterface._cancelFocusToUser(__userId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                print("取消关注用户成功：",__dict)
                //__block(__dict.objectForKey("userinfo") as! NSDictionary)
            }
            // print("_getUserProfileAtId",__dict)
        }
    }
    
    //----获取我关注的用户列表
    
    static func _getMyFocusList(__userId:String,__block:(NSArray)->Void){
        MainInterface._getMyFocusList(__userId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                print("关注用户列表：",__dict)
                __block(__dict.objectForKey("list") as! NSArray)
            }else{
                print("关注用户列表失败：",__dict.objectForKey("reason"))
            }
        }
    }
    //----获取关注我的用户列表
    
    static func _getFocusMeList(__userId:String,__block:(NSArray)->Void){
        MainInterface._getFocusMeList(__userId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                print("关注用户列表：",__dict)
                __block(__dict.objectForKey("list") as! NSArray)
            }else{
                print("关注用户列表失败：",__dict.objectForKey("reason"))
            }
        }
    }
    //-------
    
    //----获取好友列表
    static func _getFriendsList(__userId:String,__block:(NSArray)->Void){
        MainInterface._getFriendsList(__userId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                //print("好友列表：",__dict)
                __block(__dict.objectForKey("list") as! NSArray)
            }else{
                print("关注好友列表失败：",__dict.objectForKey("reason"))
            }
            // print("_getUserProfileAtId",__dict)
        }
    }
    
    
    //------消息列表
    static func _getMessages(block:(NSArray)->Void){
        let _array:NSMutableArray = NSMutableArray()
        let _n:Int = 12
        for var i:Int = 0; i<_n;++i{
            let _comment:String = _testComments?.objectAtIndex(random()%31) as! String
            let _commentDict:NSMutableDictionary = NSMutableDictionary(objects: [_testUserNames?.objectAtIndex(random()%31) as! String,_testComments?.objectAtIndex(random()%31) as! String,"111111","123456",_comment,"下午1:00","comment","333333"], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","time","type","albumId"])
            
            if i==0||i==5||i==6{
                _commentDict.setValue("好喜欢这个哈加字加字加字加字加字加字加字加字加字加字加字加字加字加字加字加字加字加字加字", forKey: "comment")
                _commentDict.setValue("", forKey: "to_userName")
                _commentDict.setValue("", forKey: "to_userId")
            }
            
            if i==3||i==10||i==29||i==20{
                _commentDict.setValue("like", forKey: "type")
            }
            if i==6{
                _commentDict.setValue("collect", forKey: "type")
            }
            
            let _pic:NSDictionary = NSDictionary(objects: ["user_2.jpg","file"], forKeys: ["url","type"])
            _commentDict.setValue(_pic, forKey: "userImg")
            
            let _albumPic:NSDictionary = NSDictionary(objects: ["pic_"+String(i%6+1)+".JPG","file"], forKeys: ["url","type"])
            _commentDict.setValue(_albumPic, forKey: "albumImg")
            
            _array.addObject(_commentDict)
            
        }
        // println(response.text)
        block(_array)
    }
    
    
    //----获取点赞列表－－－*取消
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
    
    
    static func _getLikesOfPicId(__picId:String){
        
    }
    static func _getCommentsOfPicId(__picId:String){
        
    }
    //-----提取热门图册
    static func _getHotAlbums(__block:(NSArray)->Void){
        MainInterface._getAlbumListOfUser("569602ec30765c8f0c3909d8") { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                let ablums:NSArray = __dict.objectForKey("list") as! [NSDictionary]
                __block(ablums)
            }
        }
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
    
    
    //－－－－提取妙人更新图册列表
    static func _getMyFocusTimeLine(__fromId:String,__block:(NSArray)->Void){
       
        MainInterface._getMyFocusTimeLine(__fromId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                print("关注用户更新：",__dict)
                let _arr = __dict.objectForKey("list") as! NSArray
                _focusMeList = NSMutableArray(array: _arr)
                __block(_arr)
            }else{
                print("关注用户更新失败：",__dict)
            }
        }
    }
    //－－－－提取朋友更新图册列表，内容树
    static func _getMyFriendsTimeLine(__fromId:String,__block:(NSArray)->Void){
       
        MainInterface._getMyFriendsTimeLine(__fromId) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                print("朋友更新：",__dict)
                let _arr = __dict.objectForKey("list") as! NSArray
                _friendList = NSMutableArray(array: _arr)
                __block(_arr)
            }else{
                print("朋友更新失败：",__dict)
            }
        }
    }
    //－－－－提取妙人更新图册列表---取消
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
        
        MainInterface._getCollectList { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                print("收藏列表：",__dict)
                
                let _arr:NSArray = __dict.objectForKey("list") as! NSArray
                
                let _array:NSMutableArray = NSMutableArray()
                
                for var i:Int = 0; i<_arr.count;++i{
                    let _com:NSDictionary = _arr.objectAtIndex(i) as! NSDictionary
                    if let _album = _com.objectForKey("album") as? NSDictionary{
                        
                        _array.addObject(_com)
                        
                        
//                        let _user:NSDictionary = _album.objectForKey("author") as! NSDictionary
//                        
//                        let _dict:NSMutableDictionary = NSMutableDictionary()
//                        
//                        
//                        if let _cover = _album.objectForKey("cover") as? NSDictionary{
//                           _dict.setObject(_cover, forKey: "cover")
//                        }else{
//                            let _pic:NSDictionary = NSDictionary(objects: ["no_cover","file"], forKeys: ["url","type"])
//                            _dict.setObject(_pic, forKey: "cover")
//                        }
//                        _dict.setObject(MainInterface._userAvatar(_user), forKey: "userImg")
//                        _dict.setObject(_user.objectForKey("nickname") as! String, forKey: "userName")
//                        _dict.setObject(_album.objectForKey("title") as! String, forKey: "title")
//                        _dict.setObject(_album.objectForKey("description") as! String, forKey: "description")
//                        _array.addObject(_dict)
                    }
                    
                }
                block(_array)
                
                
            }else{
               
            }
        }
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
