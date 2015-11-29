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

class MainInterface: AnyObject {
 
    static let _token:String = "429e2476-7264-4fe9-b6ad-e1e502a4678f"//80d3897b-24af-42a9-af76-3bfdea569bba
    static let _uid:String = "56557e228327cdfa7cfa192a"
    static let _basicDoman:String = "http://120.27.54.180/"
    static let _version:String = "v1"
    static let _URL_Signup:String = "user/register/"
    static let _URL_Login:String = "user/login/"
    static let _URL_Smscode:String = "user/smscode/"
    static let _URL_Album_Create:String = "album/create/"
    static let _URL_Album_Update:String="album/update/"
    static let _URL_Album_Delete:String = "album/delete/"
    static let _URL_Album_Permission:String="album/permission/"
    static let _URL_Album_List:String = "album/list/"
    static let _URL_Album_Info:String="album/info/"
    static let _URL_Pic_Create:String = "picture/create/"
    static let _URL_Pic_update:String = "picture/update/"
    
    //-----注册
    static func _signup(__mob:String, __pass:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("mobile=\(__mob)&password=\(__pass)", __url: _basicDoman+_version+"/"+_URL_Signup) { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    //-----登录
    static func _login(__mob:String, __pass:String, __block:(NSDictionary)->Void){
        CoreAction._sendToUrl("mobile=\(__mob)&password=\(__pass)", __url: _basicDoman+_version+"/"+_URL_Login ) { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    //-----获取短信码
    static func _getSmscode(){
        
    }
    //-----创建相册
    static func _createAlbum(__title:String,__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)&title=\(__title)", __url: _basicDoman+_version+"/"+_URL_Album_Create) { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    //-----获取相册列表
    static func _getMyAlbumList(__block:(NSDictionary)->Void){
        CoreAction._sendToUrl("token=\(_token)", __url: _basicDoman+_version+"/"+_URL_Album_List+"\(_uid)/0/10") { (__dict) -> Void in
            print(__dict)
            __block(__dict)
        }
    }
    
    //-----修改相册
    static func _changeAlbum(){
        
    }
    //-----删除相册
    static func _deleteAlbum(){
        
    }
    //----上传图片
    static func _uploadPic(__pic:NSDictionary,__album_id:String,__block:(NSDictionary)->Void){
        
        //559a7b34b28d4ec8e088cf0d
        
        
        switch __pic.objectForKey("type") as! String{
        case "alasset":
            let _al:ALAssetsLibrary=ALAssetsLibrary()
            
            _al.assetForURL(NSURL(string: __pic.objectForKey("url") as! String)! , resultBlock: { (asset:ALAsset!) -> Void in
                if asset != nil {
                    let __image:UIImage = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
                    
                    CoreAction._sendToUrl("token=\(_token)&album=\(__album_id)&imagend=jpg&image=\(CoreAction._imageToString(__image))", __url: _basicDoman+_version+"/"+_URL_Pic_Create) { (__dict) -> Void in
                        print(__dict)
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
                    CoreAction._sendToUrl("token=\(_token)&album=\(__album_id)&uploadpic=\(CoreAction._imageToString(image!))", __url: _basicDoman+_version+"/"+_URL_Pic_Create) { (__dict) -> Void in
                        print(__dict)
                        __block(__dict)
                    }
                    
                })
            }else{
                //self._setImage(__pic.objectForKey("url") as! String)
                let __image:UIImage = UIImage(named: __pic.objectForKey("url") as! String)!
                
                CoreAction._sendToUrl("token=\(_token)&album=\(__album_id)&uploadpic=\(CoreAction._imageToString(__image))", __url: _basicDoman+_version+"/"+_URL_Pic_Create) { (__dict) -> Void in
                    print(__dict)
                    __block(__dict)
                }
            }
            
        default:
            print("")
        }
        
    }
}