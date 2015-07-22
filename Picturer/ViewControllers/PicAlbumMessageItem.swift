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
    func _moreComment(__indexId:Int)
}


class PicAlbumMessageItem:  UITableViewCell,UITextViewDelegate{
    
    var _indexId:Int = 0
    var _indexString:String?
    
    var _type:NSString = "album" // pic
    var _user:NSDictionary?
    var _setuped:Bool = false
    var _picV:PicView?
    var _pic:UIImageView?
    var _userImg:PicView?
    var _userName_label:UILabel?
    var _updateTime_label:UILabel?
    var _albumTitle_labelV:UIView?
    var _albumTitle_label:UILabel?
    var _albumScription:UILabel?
    
    var _toolsPanel:UIView?
    var _toolsButtonPanel:UIView?
    var _toolsOpenButton:UIButton?
    var _btn_like:UIButton?
    var _btn_comment:UIButton?
    var _btn_share:UIButton?
    var _btn_collect:UIButton?
    
    var _delegate:PicAlbumMessageItem_delegate?
    
    var _cellH:CGFloat?
    
    var _defaultSize:CGSize?
    
    var _commentsPanel:UIView?
    var _commentText:UITextView?
    var _moreCommentText:UITextView?
    
    var _attributeStr:NSMutableAttributedString?
    
    
    
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
        
        
        _albumTitle_labelV = UIView(frame: CGRect(x: 0, y: 50+_picV!.frame.height-36, width: _defaultSize!.width, height: 36))
        _albumTitle_labelV?.backgroundColor = UIColor(white: 0, alpha: 0.8)
        _albumTitle_label = UILabel(frame: CGRect(x: 15, y: 8, width: _defaultSize!.width-20, height: 20))
        _albumTitle_label?.font = UIFont.boldSystemFontOfSize(20)
        //_albumTitle_label?.backgroundColor = UIColor.clearColor()
        _albumTitle_label?.textColor = UIColor.whiteColor()
        
        
        _toolsPanel = UIView(frame: CGRect(x: 0, y: 50+_picV!.frame.height, width: _defaultSize!.width, height: 36))
        
        
        _commentsPanel = UIView(frame: CGRect(x: 0, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width, height: 36))
        _commentsPanel?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        
        _commentText = UITextView()
        _moreCommentText = UITextView()
        
        _commentText?.backgroundColor =  UIColor.clearColor()
        _moreCommentText?.backgroundColor =  UIColor.clearColor()
        _moreCommentText?.tintColor = UIColor.darkGrayColor()
        
        _attributeStr = NSMutableAttributedString()
        

        _commentText!.attributedText = _attributeStr!
        
        _commentText!.delegate=self
        _commentText!.attributedText = _attributeStr!
        _commentText!.selectable=true
        _commentText!.editable=false
        _commentText?.userInteractionEnabled=true
        
        
        _moreCommentText?.delegate = self
        _moreCommentText!.selectable=true
        _moreCommentText!.editable=false
        
        //changeComments()
        
        
        _commentsPanel?.addSubview(_commentText!)
        _commentsPanel?.addSubview(_moreCommentText!)
        
        
        
        
        self.addSubview(_picV!)
        self.addSubview(_userImg!)
        self.addSubview(_userName_label!)
        self.addSubview(_updateTime_label!)
        self.addSubview(_albumTitle_labelV!)
        self.addSubview(_toolsPanel!)
        self.addSubview(_commentsPanel!)
        
        _albumTitle_labelV?.addSubview(_albumTitle_label!)
        
        
        
        
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
        
        _albumTitle_labelV?.frame = CGRect(x: 0, y: 50+_h-36, width: self.frame.width, height: 36)
        _toolsPanel!.frame = CGRect(x: 0, y: 50+_picV!.frame.height, width: _defaultSize!.width, height: 36)
        
        
        
         _commentText?.frame = CGRect(x: 5, y: 5, width: _defaultSize!.width-30, height: _commentText!.contentSize.height)
        
        
        var _moreComentH:CGFloat = 0
        
        if _moreCommentText?.text == ""{
        
        }else{
            _moreComentH = 22
        }
        _moreCommentText?.frame = CGRect(x: 5, y: _commentText!.contentSize.height-8+5, width: _defaultSize!.width-30, height: _moreComentH)
        
        _commentsPanel!.frame = CGRect(x: 10, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width-20, height: _moreCommentText!.frame.origin.y+_moreCommentText!.frame.height+10)
        
        
        //self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: _h+40)
        
        _delegate?._resized(_indexId, __height:_commentsPanel!.frame.origin.y+_commentsPanel!.frame.height+50)
    }
    
    
    
    
    ///-------------------评论-----------------------------
    
    
    
    func _setComments(__comments:NSArray,__allNum:Int){
        let _lineH:CGFloat = 20
        var _h:CGFloat
        let _n:Int = __comments.count
        
        _attributeStr = NSMutableAttributedString(string: "")
        
        for var i:Int = 0 ; i<_n; ++i{
            if i>0 {
                _attributeStr?.appendAttributedString(NSAttributedString(string: "\n"))
            }
            let _commentDict:NSDictionary = __comments.objectAtIndex(i) as! NSDictionary
            _attributeStr?.appendAttributedString(commentString(_commentDict))
            if i>1 {
                break
            }
        }
        
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        _attributeStr?.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, _attributeStr!.length))
        
        _commentText!.attributedText = _attributeStr!
       
        if _n>3{
            _moreCommentText?.attributedText = moreCommentString("查看全部"+String(_n)+"条评论",withURLString:"gogo")
        }else{
            _moreCommentText?.text = ""
        }
        
        
    }
    
    func commentString(_commentDict:NSDictionary) -> NSAttributedString {
        var boldFont = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
        var boldAttr = [NSFontAttributeName: boldFont]
        //let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),
         //   NSBackgroundColorAttributeName : UIColor.whiteColor()]
        let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor()]
        
        var attrString: NSAttributedString = userHighlightString(_commentDict.objectForKey("from_userName") as! String,withURLString: _commentDict.objectForKey("from_userId") as! String)
        
        var astr:NSMutableAttributedString = NSMutableAttributedString()
        astr.appendAttributedString(attrString)
        
        if _commentDict.objectForKey("to_userName") == nil || _commentDict.objectForKey("to_userName") as! String == "" {
            
        }else{
            attrString = NSAttributedString(string: "回复", attributes:normalAttr)
            astr.appendAttributedString(attrString)
            astr.appendAttributedString(userHighlightString(_commentDict.objectForKey("to_userName") as! String,withURLString: _commentDict.objectForKey("to_userId") as! String))
        }
        
        
        attrString = NSAttributedString(string: ": ", attributes:normalAttr)
        astr.appendAttributedString(attrString)
        attrString = NSAttributedString(string: _commentDict.objectForKey("comment") as! String, attributes:normalAttr)
        astr.appendAttributedString(attrString)
        return astr
    }
    
    func userHighlightString(string:String, withURLString:String) -> NSAttributedString {
        var attrString = NSMutableAttributedString(string: string )
        // the entire string
        var range:NSRange = NSMakeRange(0, attrString.length)
        attrString.beginEditing()
        attrString.addAttribute(NSLinkAttributeName, value:"user:"+withURLString, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.blueColor(), range:range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        attrString.endEditing()
        return attrString
    }
    
    func moreCommentString(string:String, withURLString:String) -> NSAttributedString {
         let normalAttr = [NSForegroundColorAttributeName : UIColor.brownColor()]
       var attrString = NSMutableAttributedString(string: string, attributes:normalAttr)
        
       // var attrString = NSMutableAttributedString(string: string)
        // the entire string
        var range:NSRange = NSMakeRange(0, attrString.length)
       // attrString.beginEditing()
        attrString.addAttribute(NSLinkAttributeName, value:"moreComment:"+withURLString, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.brownColor(), range:range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        //attrString.endEditing()
        return attrString
    }
    
    //-----评论代理
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        var _action:String = URL.scheme!
        
        switch _action{
        case "user":
            let _str:String = URL.absoluteString!
            let _userId:NSString =  (_str as NSString).substringFromIndex(5)
            // URL.relativeString
            println(_userId)
        case "moreComment":
            _delegate?._moreComment(_indexId)
        default:
            println("")
        }
        //println(URL.absoluteString)
        //println(URL.scheme)
        //println(URL.path)
        //println("clcik")
        return false
    }
    
    //--------------------------------------------------------
    
    
    
    
    
    
    
    
    //---------工具条------------------------
    
    
    
    
    
    
    
    
    
    func _setAlbumTitle(__str:String){
     _albumTitle_label?.text=__str
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




