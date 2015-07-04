//
//  MainInterface.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/4.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation

class MainInterface: AnyObject {
 
    static var _album_prefix = "Album_"
    
    
    class func _getAlbum(__name:String) -> NSMutableDictionary? {
        let _dic = CoreAction._loadPlist(_album_prefix+__name)
        if _dic == nil {
            return nil
        }else{
            return _dic
        }
    }
    
    class func _creatAlbum(__name:String) {
        
        var _album:AlbumObj = AlbumObj()
        _album.cover="sdsg"
        
        let _dict:NSMutableDictionary = NSMutableDictionary()
        _dict.setObject(_album.cover, forKey: "cover")
        _dict.setObject(_album.thumbImage, forKey: "thumbImage")
        _dict.setObject(_album.title, forKey: "title")
        _dict.setObject(_album.images, forKey: "images")
        
        println(_dict)
        CoreAction._savePlist(_album_prefix+__name, __dict: _dict)
    }
    
    

}