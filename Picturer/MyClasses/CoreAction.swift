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
   class func _loadPlist(__name:String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent(__name+".plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)) {
            println("file is not exist")
        } else {
           
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Loaded GameData.plist file is --> \(resultDictionary?.description)")
    }
    class func _savePlist(__name:String, __dict:NSMutableArray) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent(__name+".plist")
        
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)) {
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        } else {
        
        }
        __dict.writeToFile(path, atomically: false)
    }
    

}
