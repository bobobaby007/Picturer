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
    static let _Type_updatePic:String = "_Type_updatePic"
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
        print("time",_id,__content)
        //_getActionList()
        _actions.addObject(NSDictionary(objects: [__type,__content,_id,_Status_waiting], forKeys: ["type","content","_id","status"]))
        _saveActionsToFile()
        _doActionAtIndex(_currentIndex)
    }
    
    
    
    
    //-----上传图片到相册,返回带着默认值的pic字典
    static func _uploadPicToAlbum(__pic:NSDictionary,_album:NSDictionary)->NSDictionary{
        let _pic:NSMutableDictionary = NSMutableDictionary(dictionary: __pic)
        
        if _pic.objectForKey("_id") == nil{
            _pic.setObject("", forKey: "_id")
        }else{
            
        }
        if _pic.objectForKey("last_update_at") == nil{
            _pic.setObject(CoreAction._timeStrOfCurrent(), forKey: "last_update_at")
        }
        if _pic.objectForKey("title") == nil{
            _pic.setObject("", forKey: "title")
        }
        if _pic.objectForKey("create_at") == nil{
            _pic.setObject(CoreAction._timeStrOfCurrent(), forKey: "create_at")
        }
        
        let _localId:String=String(Int(NSDate().timeIntervalSince1970))
        _pic.setObject(_localId, forKey: "localId")
        
        if let _albumId = _album.objectForKey("_id") as? String{
            _pic.setObject(_albumId, forKey: "albumId")//---------已经有在线相册id的用在线相册id保存关联
        }else{
            let _localAlbumId:String = _album.objectForKey("localId") as! String
            _pic.setObject(_localAlbumId, forKey: "localAlbumId")//-------没有在线相册id用本地相册id关联
        }
        
        if SyncAction._uploadExist(_pic){
            
        }else{
            SyncAction._addAction(SyncAction._Type_uploadPic, __content: _pic)
        }
        
        
        return _pic
    }
    
    
    //-----上传图片是否存在于列表中
    static func _uploadExist(__pic:NSDictionary)->Bool{
        for var i:Int = 0; i<_actions.count; ++i{
            let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _actions.objectAtIndex(i) as! NSDictionary)
            
            let _type:String = _dict.objectForKey("type") as! String
            if _type == _Type_uploadPic{
                let _content:NSMutableDictionary = NSMutableDictionary(dictionary:  _dict.objectForKey("content") as! NSDictionary)
                if _content.objectForKey("url") as! String == __pic.objectForKey("url") as! String{
                    return true
                }
            }
        }
        return false
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
                MainInterface._uploadPic(_content,__block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._finishActionById(_dict.objectForKey("_id") as! Int,__dict: __dict)
                    }else{
                        SyncAction._nextAction()
                    }
                })
                break
            case _Type_newAlbum:
//                MainInterface._createAlbum(_content.objectForKey("title") as! String, __block: { (__dict) -> Void in
//                    _actioning = false
//                    if __dict.objectForKey("recode") as! Int == 200{
//                        SyncAction._finishActionById(_dict.objectForKey("_id") as! Int,__dict: __dict)
//                    }else{
//                        SyncAction._nextAction()
//                    }
//                })
                break
            case _Type_deleteAlbum:
                MainInterface._deleteAlbum(_content.objectForKey("_id") as! String, __block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._removeActionById(_dict.objectForKey("_id") as! Int)
                        SyncAction._nextAction()
                    }else{
                        SyncAction._nextAction()
                    }
                })
                break
            case _Type_updateAlbum:
                MainInterface._changeAlbum(_content.objectForKey("_id") as! String, __changeingStr: _content.objectForKey("changeingStr") as! String, __block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._removeActionById(_dict.objectForKey("_id") as! Int)
                        SyncAction._nextAction()
                    }else{
                        SyncAction._nextAction()
                    }
                })
                break
            case _Type_updatePic:
                MainInterface._changePic(_content.objectForKey("_id") as! String, __changeingStr: _content.objectForKey("changeingStr") as! String, __block: { (__dict) -> Void in
                    _actioning = false
                    if __dict.objectForKey("recode") as! Int == 200{
                        SyncAction._removeActionById(_dict.objectForKey("_id") as! Int)
                        SyncAction._nextAction()
                    }else{
                        SyncAction._nextAction()
                    }
                })
                break
            default:
                break
            }
        }
    }
    static func _nextAction(){
        print("next:",_actions)
        SyncAction._currentIndex += 1
        SyncAction._doActionAtIndex(_currentIndex)
    }
    //----完成一个动作
    static func _finishActionById(__id:Int,__dict:NSDictionary){
        for var i:Int = 0; i<_actions.count; ++i{
            let _dict:NSDictionary = _actions.objectAtIndex(i) as! NSDictionary
            let _content:NSDictionary = _dict.objectForKey("content") as! NSDictionary
            if _dict.objectForKey("_id") as! Int == __id{
                let _type:String = _dict.objectForKey("type") as! String
                switch _type{
                    case _Type_deleteAlbum:
                    
                        
                        
                    break
                case _Type_uploadPic:
                    print("图片传成功：",__dict,_content)
                    let _newPic:NSDictionary = __dict.objectForKey("info") as! NSDictionary
                    
                    
                    break
                case _Type_newAlbum:
                    let _newAlbum:NSDictionary = __dict.objectForKey("albuminfo") as! NSDictionary
                    SyncAction._refreshUpPicActionsByAlbum(_content.objectForKey("localId") as! Int,__albumId: _newAlbum.objectForKey("_id") as! String)
                    break
                default:
                    break
                }
                
                
                _actions.removeObjectAtIndex(i)
                _saveActionsToFile()
                
            }
        }
        
        
        SyncAction._removeActionById(__id)
        _nextAction()
        
    }
    
    
    
    static func _refreshUpPicActionsByAlbum(__localeAlbumId:Int,__albumId:String){
        for var i:Int = 0; i<_actions.count; ++i{
            let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _actions.objectAtIndex(i) as! NSDictionary)
            
            let _type:String = _dict.objectForKey("type") as! String
            if _type == _Type_uploadPic{
                let _content:NSMutableDictionary = NSMutableDictionary(dictionary:  _dict.objectForKey("content") as! NSDictionary)
                print(_content,__localeAlbumId)
                
                if let _localAlbumId = _content.objectForKey("localAlbumId") as? Int{
                    if _localAlbumId == __localeAlbumId{
                        _content.setObject(__albumId, forKey: "albumId")
                        _dict.setObject(_content, forKey: "content")
                        _actions[i] = _dict
                    }
                }
            }
        }
        _saveActionsToFile()
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

