//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation

class MainInterface: AnyObject {
 
    static var _token:String = ""//80d3897b-24af-42a9-af76-3bfdea569bba
    
    
    static var _uid_tem:String?
    static var _uid:String!{
        get{
            if _uid_tem==nil{
                let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                let _id:NSString?=_ud.valueForKey("uid") as? NSString
                //println(_list)
                    if _id==nil{
                        _uid_tem = ""
                        _ud.setObject(_uid_tem, forKey: "uid")
                    }else{
                        _uid_tem = _id! as String
                    }
            }
            return _uid_tem
        }
        set{
            //println("set")
            _uid_tem=newValue
            let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            _ud.setObject(_uid_tem, forKey: "uid")
            //println(_ud.dictionaryRepresentation())
        }
    }
    
    
    
    static let _basicDoman:String = "http://120.27.54.180/"
    static let _version:String = "v1"
    static let _URL_Signup:String = "user/register/"//---注册
    static let _URL_Login:String = "user/login/"//---登录
    static let _URL_ForcusUser:String = "focus/to/"//---关注用户
    static let _URL_FriendsList:String = "follow/follow/"//---我的好友列表
    static let _URL_FocusOnMeList:String = "follow/followers/"//---关注我的用户列表
    static let _URL_MyFocusList:String = "follow/following/"//---我关注的用户列表
    
    static let _URL_FriendsTimeline:String = "timeline/follow/"//---好友内容树（互相关注，朋友）
    static let _URL_MyFocusTimeline:String = "timeline/followers/"//---我关注的内容树（妙人）
    
    
    static let _URL_Smscode:String = "user/smscode/"//---获取验证码
    static let _URL_Album_Create:String = "album/create/"//---新建相册
    static let _URL_Album_Update:String="album/update/"//---更新相册
    static let _URL_Album_Delete:String = "album/delete/"//---删除相册
    static let _URL_Album_Permission:String="album/permission/"//---设置相册权限
    static let _URL_Album_List:String = "album/list/"//---相册列表
    static let _URL_Album_Info:String="album/info/"//---相册信息
    static let _URL_Pic_Create:String = "picture/create/"//---新建图片
    static let _URL_Pic_update:String = "picture/update/"//---图片更新
    static let _URL_Pic_list:String = "picture/list/"//---相册里图片列表
    static let _URL_User_Info:String = "user/info/"//---用户信息
    static let _URL_User_Update:String = "user/update/"//---更新用户信息
    static let _URL_User_Avatar:String = "user/avatar/"//---更新用户头像
    static let _URL_Pic_like:String = "like/picture/"//---图片点赞
    static let _URL_Album_like:String = "like/album/"//-----相册点赞
    
    
    
    //-----判断是否登录
    static func _isLogined()->Bool{
        
        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let _tok:String = _ud.valueForKey("token") as? String {
            _token = _tok
            
            if _token == ""{
                return false
            }else{
                return true
            }
            
        }else{
            return false
        }
    }
    static func _saveToken(__token:String){
        let _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        _ud.setObject(__token, forKey: "token")
        _token = __token
    }
    //-----注册
    static func _signup(__mob:String, __pass:String,__nickname:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("mobile=\(__mob)&password=\(__pass)&nickname=\(__nickname)", __url: _basicDoman+_version+"/"+_URL_Signup) { (__dict) -> Void in
        
            if __dict.objectForKey("recode") as! Int == 200{
                MainInterface._saveToken(__dict.objectForKey("token") as! String)
            }
            
            __block(__dict)
        }
    }
    //-----登录
    static func _login(__mob:String, __pass:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("mobile=\(__mob)&password=\(__pass)", __url: _basicDoman+_version+"/"+_URL_Login ) { (__dict) -> Void in
            print(__dict)
            if __dict.objectForKey("recode") as! Int == 200{
                let _user:NSDictionary = __dict.objectForKey("userinfo") as! NSDictionary
                MainInterface._saveToken(_user.objectForKey("token") as! String)
                
                _uid = _user.objectForKey("_id") as! String
            }
            __block(__dict)
        }
    }
    //-----获取用户信息
    static func _getMyUserInfo(__userId:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_User_Info+"\(__userId)") { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    //-----更新用户信息
    static func _updateUserInfo(__dict:NSDictionary, __block:(NSDictionary)->Void){
        var _str:String = ""
        
        _str = _str+"&nickname="+(__dict.objectForKey("nickname") as! String)
        _str = _str+"&sex="+(String(__dict.objectForKey("sex") as! Int))
        _str = _str+"&signature="+(__dict.objectForKey("signature") as! String)
        //_str = _str+"&email="+(__dict.objectForKey("email") as! String)
        //_str = _str+"&country="+(__dict.objectForKey("country") as! String)
        
        CoreAction._sendToUrl("token=\(_token)"+_str, __url: _basicDoman+_version+"/"+_URL_User_Update) { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    //-----关注用户
    static func _focusToUser(__userId:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_ForcusUser+"\(__userId)") { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    //-----更新用户头像
    static func _changeUserAvatar(__image:UIImage,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)&avatar=\(CoreAction._imageToString(__image))&imagend=jpg", __url: _basicDoman+_version+"/"+_URL_User_Avatar) { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    //-----我关注的用户列表
    static func _getMyFocusList(__userId:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_MyFocusList+"\(__userId)") { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    
    
    //-----我关注的用户的时间树
    static func _getMyFocusTimeLine(__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_MyFocusTimeline) { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    
    //---获取我的好友列表
    static func _getFriendsList(__uid:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_FriendsList+"\(__uid)") { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    static func _getUserInfo(__userId:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_User_Info+"\(__userId)") { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    //-----获取短信码
    static func _getSmscode(){
        
    }
    //-----创建相册
    static func _createAlbum(__Str:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)"+__Str, __url: _basicDoman+_version+"/"+_URL_Album_Create) { (__dict) -> Void in
           // print(__dict)
            __block(__dict)
        }
    }
    //-----获取我自己的相册列表
    static func _getMyAlbumList(__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_Album_List+"\(_uid)/0/100") { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    //-----获取某用户相册列表
    static func _getAlbumListOfUser(__userId:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_Album_List+"\(__userId)/0/100") { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    //----获取相册信息
    static func _getAlbumInfo(__albumId:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_Album_Info+"\(__albumId)") { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    //-----相册里的图片
    static func _getImagesOfAlbum(__albumId:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_Pic_list+"\(__albumId)/0/100") { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    //-----修改相册
    static func _changeAlbum(__albumId:String,__changeingStr:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)"+__changeingStr, __url: _basicDoman+_version+"/"+_URL_Album_Update+__albumId) { (__dict) -> Void in
            //print(__dict)
            __block(__dict)
        }
    }
    //-----删除相册
    static func _deleteAlbum(__albumId:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_Album_Delete+__albumId) { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    //----上传图片
    static func _uploadPic(__pic:NSDictionary,__block:(NSDictionary)->Void){
        
        //559a7b34b28d4ec8e088cf0d
        if __pic.objectForKey("type") == nil{
            print("图片有问题:",__pic)
            return
        }
        switch __pic.objectForKey("type") as! String{
        case "alasset":
            let _al:ALAssetsLibrary=ALAssetsLibrary()
            _al.assetForURL(NSURL(string: __pic.objectForKey("url") as! String)! , resultBlock: { (asset:ALAsset!) -> Void in
                if asset != nil {
                    let __image:UIImage = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
                    CoreAction._sendToUrl("token=\(_token)&&imagend=jpg&image=\(CoreAction._imageToString(__image))", __url: _basicDoman+_version+"/"+_URL_Pic_Create) { (__dict) -> Void in
                       // print(__dict)
                        __block(__dict)
                    }
                }else{
                    
                }
                }, failureBlock: { (error:NSError!) -> Void in
                    __block(NSDictionary(objects: ["failed"], forKeys: ["info"]))
            })
            
        case "file":
            let _str = __pic.objectForKey("url") as! String
            let _range = _str.rangeOfString("http")
            if _range?.count != nil{
                ImageLoader.sharedLoader.imageForUrl(__pic.objectForKey("url") as! String, completionHandler: { (image, url) -> () in
                    // _setImage(image)
                    //println("")
                    if image==nil{
                        //--加载失败
                        print("图片加载失败:",__pic.objectForKey("url"))
                        __block(NSDictionary(objects: ["failed"], forKeys: ["info"]))
                        return
                    }
                    CoreAction._sendToUrl("token=\(_token)&uploadpic=\(CoreAction._imageToString(image!))", __url: _basicDoman+_version+"/"+_URL_Pic_Create) { (__dict) -> Void in
                        //print(__dict)
                        __block(__dict)
                    }
                    
                })
            }else{
                //self._setImage(__pic.objectForKey("url") as! String)
                let __image:UIImage = UIImage(named: __pic.objectForKey("url") as! String)!
                
                CoreAction._sendToUrl("token=\(_token)&uploadpic=\(CoreAction._imageToString(__image))", __url: _basicDoman+_version+"/"+_URL_Pic_Create) { (__dict) -> Void in
                    //print(__dict)
                    __block(__dict)
                }
            }
            
        default:
            print("")
        }
        
    }
    //-----修改图片
    static func _changePic(__picId:String,__changeingStr:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)"+__changeingStr, __url: _basicDoman+_version+"/"+_URL_Pic_update+__picId) { (__dict) -> Void in
            print("修改图片成功：",__dict)
            __block(__dict)
        }
    }
    
    //---发给微信朋友圈
    static func _sendWXContentUser(__title:String,__des:String, __url:String,__pic:NSDictionary) {//分享给朋友！！
        _getSmallPic(__pic) { (__image) -> Void in
            let message:WXMediaMessage = WXMediaMessage()
            message.title = __title
            message.description = __des
            message.setThumbImage(__image);
            let ext:WXWebpageObject = WXWebpageObject();
            ext.webpageUrl = __url
            message.mediaObject = ext
            let resp = GetMessageFromWXResp()
            resp.message = message
            WXApi.sendResp(resp);
        }
        
    }
    //---发送微信朋友圈
    static func _sendWXContentFriend(__title:String,__des:String,__url:String,__pic:NSDictionary) {//分享朋友圈
        _getSmallPic(__pic) { (__image) -> Void in
            let message:WXMediaMessage = WXMediaMessage()
            message.title = __title
            message.description = __des
            message.setThumbImage(__image);
            let ext:WXWebpageObject = WXWebpageObject();
            ext.webpageUrl = __url
            message.mediaObject = ext
            message.mediaTagName = "摄影"
            let req = SendMessageToWXReq()
            req.scene = 1
            req.text = "分享图片："
            req.bText = false
            req.message = message
            WXApi.sendReq(req);
        }
    }
    //-------有缩略图提取小图
    static func _getSmallPic(__pic:NSDictionary,__block:(UIImage)->Void){
        let _image:PicView = PicView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        if let _url = __pic.objectForKey("thumbnail") as? String{
            
            _image._setPic(NSDictionary(objects:[MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{_ in
                __block(CoreAction._captureImage(_image))
            })
            
        }
        _image._setPic(__pic, __block:{_ in
            __block(CoreAction._captureImage(_image))
        })

    }
    
    //--------＝＝＝＝＝＝＝＝＝＝＝社交部分＝＝＝＝＝＝＝＝＝
    
    //---转换性别为文字
    static func _sexStr(__i:Int)->String{
        switch __i{
        case 0:
            return "男"
            break
        case 1:
            return "女"
            break
        default:
            return ""
        }
    }
    static func _userAvatar(__userInfo:NSDictionary)->NSDictionary{
        var _dict:NSDictionary
        _dict = NSDictionary(objects: ["icon_1","file"], forKeys: ["url","type"])
        if let _avatar = __userInfo.objectForKey("avatar") as? String{
            if _avatar == ""{
                
            }else{
                _dict = NSDictionary(objects: [ MainInterface._imageUrl(_avatar),"file"], forKeys: ["url","type"])
            }
        }else{
            
        }
        
        return _dict
        
        
    }
    //----获取图册完整地址,用于分享
    static func _albumUrl(__albumId:String)->String{
        let _url:String = _basicDoman + _version + "/share/album/" + __albumId
        return _url
    }
    
    //-----获取图片完整url
    static func _imageUrl(__str:String)->String{
        let _url:String = _basicDoman + "uploadDir/" + __str
        return _url
    }
    
    
    //--------------------社交部分
    
    
    
}