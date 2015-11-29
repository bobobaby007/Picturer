//
//  DoubanApis.swift
//  Picturer
//
//  Created by Bob Huang on 15/11/28.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation

class DoubanApis: NSObject {
    static func _getLargeImageOfUrl(__str:String)->String{
        if !_isDoubanLink(__str){
            return __str
        }
        var str:String = __str.stringByReplacingOccurrencesOfString("/photo/thumb/", withString: "/photo/large/")
        
        str = str.stringByReplacingOccurrencesOfString("/photo/photo/", withString: "/photo/large/")
        
        return str
    }
    static func _isDoubanLink(_str:String)->Bool{
        
        let _range = _str.rangeOfString("http")
        if _range?.count != nil{
            return true
        }else{
            print("不是豆瓣链接")
            return false
        }
    }
}
