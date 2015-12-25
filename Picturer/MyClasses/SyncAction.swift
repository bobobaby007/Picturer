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
    static let _Type_uploadPic:String = "_Type_uploadPic"
    static let _Type_newAlbum:String = "_Type_newAlbum"
    static let _Type_deleteAlbum:String = "_Type_deleteAlbum"
    static let _Type_updateAlbum:String = "_Type_updateAlbum"
    static let _Status_waiting:String = "_Status_waiting"
    //static  var _actions:NSMutableArray = []
    static var _aList:NSMutableArray?
    static var _currentIndex:Int = 0
    static var _actioning:Bool = false
    static var _actions:NSMutableArray!{
        get{
            if _aList==nil{
                if CoreAction._fileExistAtDocument(_listName+".plist"){
                    //print("存在")
                }else{
                    //print("不存在")
                    _aList = []
                    CoreAction._saveArrayToFile(_aList!, __fileName: _listName+".plist")
                }
                if let _arr:NSArray = CoreAction._getArrayFromFile(_listName+".plist"){
                _aList = NSMutableArray(array: _arr)
                    
                }
            }
            return _aList
        }
    }
    
    static func _saveActionsToFile(){
        CoreAction._saveArrayToFile(_aList!, __fileName: _listName+".plist")
    }
    //----添加一个动作。_id为动作对应id
    static func _addAction(__type:String,__content:NSDictionary){
        let _id:Int = Int(NSDate().timeIntervalSince1970)
        print("time",_id)
        //_getActionList()
        _actions.addObject(NSDictionary(objects: [__type,__content,_id,_Status_waiting], forKeys: ["type","content","_id","status"]))
        
        _saveActionsToFile()
        
        _doActionAtIndex(_currentIndex)
        
    }
    static func _removeActionAtId(__id:Int)->Void{
        for var i:Int = 0 ; i < _actions.count ; ++i{
            if let _dict:NSDictionary = _actions.objectAtIndex(i) as? NSDictionary{
                if _dict.objectForKey("_id") as! Int == __id{
                    _actions.removeObjectAtIndex(i)
                    _saveActionsToFile()
                    return
                }
            }
        }
    }
    static func _doActionAtIndex(__index:Int){
        if __index<0||__index>=_actions.count{
            return
        }
        if _actioning{
            return
        }
        _actioning = true
        if let _dict:NSDictionary = _actions.objectAtIndex(__index) as? NSDictionary{
             //let _id:Int = _dict.objectForKey("_id") as! Int
            let _content:NSDictionary = _dict.objectForKey("content") as! NSDictionary
            switch _dict.objectForKey("type") as! String{
            case _Type_uploadPic:
                MainInterface._uploadPic(_content, __album_id: _content.objectForKey("albumId") as! String, __block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._removeActionById(_dict.objectForKey("_id") as! Int)
                        SyncAction._currentIndex += 1
                        SyncAction._doActionAtIndex(_currentIndex)
                    }
                })
                break
            case _Type_newAlbum:
                MainInterface._createAlbum(_content.objectForKey("title") as! String, __block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._removeActionById(_dict.objectForKey("_id") as! Int)
                        SyncAction._currentIndex += 1
                        SyncAction._doActionAtIndex(_currentIndex)
                    }
                })
                break
            case _Type_deleteAlbum:
                MainInterface._deleteAlbum(_content.objectForKey("_id") as! String, __block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._removeActionById(_dict.objectForKey("_id") as! Int)
                        SyncAction._currentIndex += 1
                        SyncAction._doActionAtIndex(_currentIndex)
                    }
                })
                break
            case _Type_updateAlbum:
                MainInterface._changeAlbum(_content.objectForKey("_id") as! String, __changeingStr: _content.objectForKey("changeingStr") as! String, __block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._removeActionById(_dict.objectForKey("_id") as! Int)
                        SyncAction._currentIndex += 1
                        SyncAction._doActionAtIndex(_currentIndex)
                    }
                })
                break
            default:
                break
            }
        }
    }
    //----完成一个动作
    static func _finishActionById(__id:Int){
        for var i:Int = 0; i<_actions.count; ++i{
            let _dict:NSDictionary = _actions.objectAtIndex(i) as! NSDictionary
            if _dict.objectForKey("_id") as! Int == __id{
                let _type:String = _dict.objectForKey("type") as! String
                switch _type{
                    case _Type_deleteAlbum:
                    
                    break
                default:
                    break
                }
                
                
                _actions.removeObjectAtIndex(i)
                _saveActionsToFile()
                return
            }
        }
    }
    
    static func _removeActionById(__id:Int){
        for var i:Int = 0; i<_actions.count; ++i{
            let _dict:NSDictionary = _actions.objectAtIndex(i) as! NSDictionary
            if _dict.objectForKey("_id") as! Int == __id{
                _actions.removeObjectAtIndex(i)
                _saveActionsToFile()
                return
            }
        }
    }
    
    
    static func _newAlbumOkOfId(__id:Int){
        for var i:Int = 0; i<_actions.count; ++i{
            let _dict:NSDictionary = _actions.objectAtIndex(i) as! NSDictionary
            if _dict.objectForKey("_id") as! Int == __id{
                _actions.removeObjectAtIndex(i)
                _saveActionsToFile()
                return
            }
        }
    }
    static func _changeActionById(__id:Int){
        
    }
}

