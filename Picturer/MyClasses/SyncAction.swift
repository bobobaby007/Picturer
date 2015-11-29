//
//  SyncAction.swift
//  Picturer
//
//  Created by Bob Huang on 15/11/27.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class SyncAction: NSObject{
    static let _listName:String = "SyncActionList"
    static let _Type_uploadPic:String = "_uploadPic"
    
    
    static  var _actions:NSMutableArray = []
    static var _currentIndex:Int = 0
   
    static func _addAction(__type:String,__content:NSDictionary){
        let _id:Int = Int(NSDate().timeIntervalSince1970)
        print("time",_id)
        //_getActionList()
        _actions.addObject(NSDictionary(objects: [__type,__content,_id], forKeys: ["type","content","id"]))
        
        CoreAction._saveArrayToFile(_actions, __fileName: _listName)
    }
    static func _removeActionAtId(__id:Int)->Void{
        for var i:Int = 0 ; i < _actions.count ; ++i{
            if let _dict:NSDictionary = _actions.objectAtIndex(i) as? NSDictionary{
                if _dict.objectForKey("id") as! Int == __id{
                    _actions.removeObjectAtIndex(i)
                    CoreAction._saveArrayToFile(_actions, __fileName: _listName)
                    return
                }
            }
            
        }
    }
    static func _doActionAtIndex(__index:Int){
        if let _dict:NSDictionary = _actions.objectAtIndex(__index) as? NSDictionary{
            let _id:Int = _dict.objectForKey("id") as! Int
            let _content:NSDictionary = _dict.objectForKey("content") as! NSDictionary
            switch _dict.objectForKey("type") as! String{
            case _Type_uploadPic:
                
                MainInterface._uploadPic(_content.objectForKey("pic") as! NSDictionary, __album_id: _content.objectForKey("albumId") as! String, __block: { (__dict) -> Void in
                    
                })
                
                
                break
            default:
                break
            }
        }
    }
    
    
    static func _getActionList(){
        if CoreAction._fileExistAtDocument(_listName+".plist"){
            
        }else{
            CoreAction._saveArrayToFile(_actions, __fileName: _listName)
        }
        
        
        if let _arr:NSArray = CoreAction._getArrayFromFile(_listName){
            _actions = NSMutableArray(array: _arr)
        }
    }
    
    
    
    
    
    
   
    
}

