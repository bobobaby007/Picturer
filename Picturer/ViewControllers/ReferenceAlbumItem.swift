//
//  PicAlbumMessageItem.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol ReferenceAlbumItem_delegate:NSObjectProtocol{
    func _viewUser(__userId:String)
    func _viewAlbum(__albumIndex:Int)
}

class ReferenceAlbumItem:  UITableViewCell,UITextViewDelegate{
    var _picsW:CGFloat = 0
    let _gapForPic:CGFloat = 2
    
    var _alerter:MyAlerter?
    
    var _bottomOfPic:CGFloat = 0 //---到图片底部的位置
    
    let _gap:CGFloat = 15
    var _indexId:Int = 0
    var _indexString:String?
    
    
    
    var _user:NSDictionary?
    var _userId:String?
    var _setuped:Bool = false
    var _picV:PicView? = PicView()
    //var _pic:UIImageView?
    
    var _userImg:PicView?
    var _userBtn:UIButton?
    var _albumTitle_labelV:UIView?
    var _albumTitle_label:UITextView?
    
    var _titleStr:String? = ""
    
    
    weak var _delegate:ReferenceAlbumItem_delegate?
    
    var _cellH:CGFloat?
    
    var _defaultSize:CGSize?
    
    var _commentsPanel:UIView?
    var _commentText:UITextView?
    var _moreCommentText:UITextView?
    
    var _attributeStr:NSMutableAttributedString?
    
    
    var _buttonTap:UITapGestureRecognizer?
    
    
    var _blackBg:UIView?
    
    var _statusText:UITextView?//----显示为状态时文字
    
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
        self.backgroundColor = UIColor.clearColor()
        
        
        
        _blackBg = UIView(frame: CGRect(x: 0, y: 0, width: _defaultSize!.width, height: _defaultSize!.height))
        _blackBg?.backgroundColor = UIColor(white: 0, alpha: 0.1)
        _blackBg?.userInteractionEnabled = false
        
        
        
        
        _buttonTap = UITapGestureRecognizer(target: self, action: #selector(ReferenceAlbumItem._buttonTapHander(_:)))
        //println(_defaultSize!.width)
        
        
        
        _userImg = PicView(frame: CGRect(x: Config._gap, y: 6.5, width: 35, height: 35))
        _userImg?.center = CGPoint(x: Config._gap+_userImg!.frame.width/2, y: 45/2)
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?.layer.masksToBounds=true
        _userImg?.layer.cornerRadius = _userImg!.frame.width/2
        
        _userImg?.addGestureRecognizer(_buttonTap!)
        
        
        _userBtn = UIButton(frame: CGRect(x: _userImg!.frame.origin.x+_userImg!.frame.width+8.5, y: 8-3, width: 200, height: 12))
        _userBtn?.contentEdgeInsets = UIEdgeInsetsZero
        
        _userBtn?.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        _userBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        _userBtn?.titleLabel?.font = Config._font_social_cell_name
        _userBtn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
       
        
        
       
        setupPic()
        self.addSubview(_blackBg!)
        setupTitle()
        
        
        self.addSubview(_userImg!)
        self.addSubview(_userBtn!)
        _albumTitle_labelV?.addSubview(_albumTitle_label!)
        
        
        
        
        _setuped=true
    }
    
    func _getUserInfo(){
        Social_Main._getUserProfileAtId(_userId!) {[weak self] (__dict) -> Void in
            if self != nil{
                print("用户信息：",__dict)
                self!._user = __dict
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?._getUserInfoOk()
                })
                
            }
            
        }
    }
    func _getUserInfoOk(){
        //_setAlbumTitle(_titleStr!)
        _setUserImge(MainInterface._userAvatar(_user!))
        _setUserName( _user?.objectForKey("nickname") as! String)
        
        _setAlbumTitle(_titleStr!)
    }
    
    //---设定图片
    func setupPic(){
        _picV = PicView(frame: CGRect(x: 0, y: 0, width: _defaultSize!.width, height: _defaultSize!.width))
        _picV?._setImage("noPic.png")
        _picV?.scrollEnabled=false
        _picV?.maximumZoomScale = 1
        _picV?.minimumZoomScale = 1
        _picV?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _picV?.layer.masksToBounds = true
        
        let _tapPic:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReferenceAlbumItem._buttonTapHander(_:)))
        _picV?.addGestureRecognizer(_tapPic)
        
        _bottomOfPic = _picV!.frame.origin.y + _picV!.frame.height
        
        self.addSubview(_picV!)
    }
    //---设定标题
    func setupTitle(){
        _albumTitle_labelV = UIView(frame: CGRect(x: 0, y: _bottomOfPic-30, width: _defaultSize!.width, height: 30))
        _albumTitle_labelV?.backgroundColor = UIColor.clearColor()
        _albumTitle_labelV?.userInteractionEnabled=false
        _albumTitle_label = UITextView(frame: CGRect(x: 15, y: 8, width: _defaultSize!.width-2*_gap, height: 12))
        
        _albumTitle_label?.pagingEnabled=false
        _albumTitle_label?.userInteractionEnabled = false
        _albumTitle_label?.textContainer.lineFragmentPadding=0
        _albumTitle_label?.textContainerInset = UIEdgeInsetsZero
        _albumTitle_label?.backgroundColor = UIColor.clearColor()
        _albumTitle_label?.editable=false
        _albumTitle_label?.selectable=false
        //_albumTitle_label?.userInteractionEnabled=false
        _albumTitle_label?.textColor = UIColor.whiteColor()
        _albumTitle_label?.font = Config._font_social_reference_albumTitle
        _albumTitle_label?.textColor = UIColor.whiteColor()
        self.addSubview(_albumTitle_labelV!)
    }
    //--------------------------------------------------------
    func _buttonTapHander(__tap:UITapGestureRecognizer){
        switch __tap.view!{
        case _userImg!:
            _delegate?._viewUser(_userId!)
            return
        case _picV!:
            _delegate?._viewAlbum(_indexId)
        default:
            
            return
        }
    }
    
    override func removeFromSuperview() {
        //print("out")
       
    }
    
    func _setAlbumTitle(__str:String){
        if _albumTitle_label == nil{
            return
        }
        _titleStr = __str
        
        if __str==""{
            _albumTitle_label?.text="未命名图册"
        }else{
            
            print(_albumTitle_label)
            _albumTitle_label!.text=__str
            
        }
        
        
        let _size:CGSize = _albumTitle_label!.sizeThatFits(CGSize(width: _defaultSize!.width-2*_gap, height: CGFloat.max))
       
        var _lineNum:CGFloat = 1
        if _size.height>24{
            _lineNum = 2
        }
        _albumTitle_labelV?.frame = CGRect(x: 0, y: _bottomOfPic-30*_lineNum, width: _defaultSize!.width, height:30*_lineNum)
        _albumTitle_label?.frame = CGRect(x: _gap, y: (_albumTitle_labelV!.frame.height-_size.height)/2, width: _size.width, height: _size.height)
        
        _userImg?.frame.origin.y = _bottomOfPic - _albumTitle_labelV!.frame.height - _userImg!.frame.height
        _userBtn?.frame.origin.y = _bottomOfPic - _albumTitle_labelV!.frame.height - _userImg!.frame.height + 6
    }
    
    
    func _setUserName(__str:String){
        _userBtn?.setTitle(__str, forState: UIControlState.Normal)
    }
    func _setUserImge(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: { (__dict) -> Void in
            
        })
    }
    
    func _setPic(__pic:NSDictionary){
        //println(__pic)
        //  _pic?.image = UIImage(named: __pic.objectForKey("url") as! String)
        if let _url = __pic.objectForKey("thumbnail") as? String{
            _picV!._setPic(NSDictionary(objects:[MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{_ in
                
            })
            return
        }else{
            _picV!._setPic(__pic, __block:{_ in
               
            })
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // println("ww")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




