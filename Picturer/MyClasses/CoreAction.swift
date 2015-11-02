//
//  CoreAction.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/3.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation

class CoreAction: AnyObject {
    //---读取plist
    
    class func _fileFullPath(__name:String) -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path:String = (documentsDirectory as NSString).stringByAppendingPathComponent(__name)
        return path
    }
    
   class func _loadPlist(__name:String) -> NSMutableDictionary? {
    
        let path = _fileFullPath(__name+".plist")
        let fileManager = NSFileManager.defaultManager()
    
       // println(path)
        if(!fileManager.fileExistsAtPath(path)) {
            print("file is not exist"+path)
        } else {
           
        }
       let _result = NSMutableDictionary(contentsOfFile: path)
       if _result == nil {
            return nil
        }else{
            return _result
        }
    }
    //---文件是否存在
    class func _ifHasFile(__name:NSString)->Bool{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = (documentsDirectory as NSString).stringByAppendingPathComponent(__name as String)
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(path)
    }
    //－－－－保存文件
    class func _savePlist(__name:String, __dict:NSMutableDictionary) {
        
        let path = _fileFullPath(__name+".plist")
        
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)) {
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        } else {
        
        }

        __dict.writeToFile(path, atomically: true)
    }
    
    
    
    //------

}
