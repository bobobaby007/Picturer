//
//  UploadingList.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/6.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation


protocol UploadingList_delegate:NSObjectProtocol{
    func _uploadOk(__oldPic:NSDictionary,__newPic:NSDictionary)
}

class UploadingList:NSObject {
    static let _Type_uploadPic:String = "_Type_uploadPic"
    var _uploadingList:NSMutableArray = []
    var _uploadedList:NSMutableArray = []
    weak var _delegate:UploadingList_delegate?
    override init() {
        super.init()
    }
    
    func _addNewPic(__pic:NSDictionary)->Int{
        let _localId:Int = __pic.objectForKey("localId") as! Int
        
        _uploadingList.addObject(__pic)
        MainInterface._uploadPic(__pic,__withStr: "",__block: { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self._removeFrom(_localId,__atArray: self._uploadingList)
                    //print(__dict)
                    self._delegate?._uploadOk(__pic, __newPic: __dict.objectForKey("info") as! NSDictionary)
                })
            }else{
                
                print(__dict)
            }
        })
        return _localId
    }
    func _removeFrom(__localId:Int,var __atArray:NSMutableArray){
        let _a:NSMutableArray = NSMutableArray(array: __atArray)
        for i:Int in 0 ..< _a.count {
            let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _a.objectAtIndex(i) as! NSDictionary)
            if _dict.objectForKey("localId") as! Int == __localId{
                _a.removeObjectAtIndex(i)
            }
        }
        __atArray = _a
    } 
    //-----图片是否存在于列表中
    func _isUploading(__pic:NSDictionary)->Bool{
        if let _localId:Int = __pic.objectForKey("localId") as? Int{
            for i:Int in 0 ..< _uploadingList.count{
                let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _uploadingList.objectAtIndex(i) as! NSDictionary)
                if _localId == _dict.objectForKey("localId") as! Int{
                    return true
                }
                
            }
        }
        return false
    }

    
}
