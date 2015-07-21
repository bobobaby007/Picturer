//
//  PicAlbumMessageItem.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol PicAlbumMessageItem_delegate:NSObjectProtocol{
    func _resized(__indexId:Int,__height:CGFloat)
}


class PicAlbumMessageItem:  UITableViewCell{
    
    
    var _indexId:Int = 0
    var _type:NSString = "album" // pic
    var _user:NSDictionary?
    var _setuped:Bool = false
    var _picV:PicView?
    var _pic:UIImageView?
    var _userImg:PicView?
    var _userName_label:UILabel?
    var _updateTime_label:UILabel?
    var _albumTitle_label:UILabel?
    var _albumScription:UILabel?
    
    var _toolsPanel:UIView?
    var _toolsButton:UIView?
    var _btn_like:UIButton?
    var _btn_comment:UIButton?
    var _btn_share:UIButton?
    var _btn_collect:UIButton?
    
    var _delegate:PicAlbumMessageItem_delegate?
    
    var _cellH:CGFloat?
    
    var _defaultSize:CGSize?
    
    
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        //setup()
    }
    override func didMoveToSuperview() {
        // println(self.frame.width)
        //setup()
    }
    
    
    func setup(__size:CGSize){
        if _setuped{
            return
        }
        _defaultSize=__size
        //println(_defaultSize!.width)
        _picV = PicView(frame: CGRect(x: 0, y: 50, width: _defaultSize!.width, height: 340))
        _picV?._setImage("noPic.png")
        _picV?.scrollEnabled=false
        _picV?.maximumZoomScale = 1
        _picV?.minimumZoomScale = 1
        _picV?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _picV?.layer.masksToBounds = true
        
        _userImg = PicView(frame: CGRect(x: 15, y: 7, width: 36, height: 36))
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?.layer.masksToBounds=true
        _userImg?.layer.cornerRadius = 18
        
        _userName_label = UILabel(frame: CGRect(x: 70, y: 15, width: 200, height: 20))
        _userName_label?.font = UIFont.systemFontOfSize(12)
        _updateTime_label = UILabel(frame: CGRect(x: _defaultSize!.width-150, y: 15, width: 140, height: 20))
        
        _updateTime_label?.textAlignment = NSTextAlignment.Right
        _updateTime_label?.font = UIFont.systemFontOfSize(12)
        
        _albumTitle_label = UILabel(frame: CGRect(x: 0, y: 50, width: _defaultSize!.width, height: 140))
        _albumTitle_label?.font = UIFont.systemFontOfSize(20)
        _albumTitle_label?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        
        
        
        self.addSubview(_picV!)
        self.addSubview(_userImg!)
        self.addSubview(_userName_label!)
        self.addSubview(_updateTime_label!)
        self.addSubview(_picV!)
        
        _setuped=true
    }
    
    func _refreshView(){
        var _imgH:CGFloat! = _picV?._imgView?.image?.size.height
        var _imgW:CGFloat! = _picV?._imgView?.image?.size.width
        
        var _h:CGFloat = 340
        if _imgH != nil{
         _h = _imgH*(self.frame.width/_imgW)
        }
        _picV?.frame = CGRect(x: 0, y: 50, width: self.frame.width, height: _h)
        _picV?._refreshView()
        
        //self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: _h+40)
        
        _delegate?._resized(_indexId, __height:_picV!.frame.origin.y+_picV!.frame.height+50)
    }
    func _setUserName(__str:String){
        _userName_label?.text=__str
    }
    func _setUpdateTime(__str:String){
        _updateTime_label?.text=__str
    }
    func _setUserImge(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: { (__dict) -> Void in
            
        })
    }
    func _setPic(__pic:NSDictionary){
        //println(__pic)
       //  _pic?.image = UIImage(named: __pic.objectForKey("url") as! String)
        _picV?._setPic(__pic, __block: { (__dict) -> Void in
           self._refreshView()
            
        })
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
       // println("ww")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setup()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
