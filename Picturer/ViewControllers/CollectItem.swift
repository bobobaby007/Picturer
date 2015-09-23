//
//  PicAlbumMessageItem.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol CollectItem_delegate:NSObjectProtocol{
    func _resized(__indexId:Int,__height:CGFloat)
    func _moreComment(__indexId:Int)
    func _viewUser(__userId:String)
    func _viewAlbum(__albumIndex:Int)
    func _moreLike(__indexId:Int)
    func _buttonAction(__action:String,__dict:NSDictionary)
}


class CollectItem:  UITableViewCell,UITextViewDelegate{
    
    let _gapForPic:CGFloat = 2
    
    var _bottomOfPic:CGFloat = 0 //---到图片底部的位置
    
    let _gap:CGFloat = 15
    var _indexId:Int = 0
    var _indexString:String?
    
    var _user:NSDictionary?
    var _userId:String?
    var _setuped:Bool = false
    var _picV:PicView?
    
    
    var _userImg:PicView?
    var _userName_label:UILabel?
    var _updateTime_label:UILabel?
    var _albumTitle_labelV:UIView?
    var _albumTitle_label:UITextView?
    var _description:UILabel?
    
    
    var _btn_like:UIButton = UIButton()
    var _btn_comment:UIButton = UIButton()
    var _btn_share:UIButton = UIButton()
    var _btn_collect:UIButton = UIButton()
    
    var _delegate:CollectItem_delegate?
    
    var _cellH:CGFloat?
    
    var _defaultSize:CGSize?
    
    
    var _attributeStr:NSMutableAttributedString?
    
    
    var _tapC:UITapGestureRecognizer?
    
    var _buttonTap:UITapGestureRecognizer?
    
    
    var _bgV:UIView?
    var _container:UIView?
    
    
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
        
        

        
        
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("_tapHander:"))
        _buttonTap = UITapGestureRecognizer(target: self, action: Selector("_buttonTapHander:"))
        //println(_defaultSize!.width)
        
        
        
        _userImg = PicView(frame: CGRect(x: 15+_gap, y: 12+_gap, width: 32, height: 32))
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?.layer.masksToBounds=true
        _userImg?.layer.cornerRadius = 16
        
        _userImg?.addGestureRecognizer(_buttonTap!)
        
        
        _userName_label = UILabel(frame: CGRect(x: 59+_gap, y: 23+_gap, width: 200, height: 12))
        _userName_label?.font = UIFont.boldSystemFontOfSize(14)
        _userName_label?.textColor = UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1)
        
        _updateTime_label = UILabel(frame: CGRect(x: _defaultSize!.width-155-_gap, y: 25+_gap, width: 140, height: 12))
        
        _updateTime_label?.textAlignment = NSTextAlignment.Right
        _updateTime_label?.font = UIFont.systemFontOfSize(12)
   
        _picV = PicView(frame: CGRect(x: _gap+0.5, y: _gap+55, width: _defaultSize!.width-2*_gap-2, height:_defaultSize!.width-2*_gap-1))
        _picV?._setImage("noPic.png")
        _picV?.scrollEnabled=false
        _picV?.maximumZoomScale = 1
        _picV?.minimumZoomScale = 1
        _picV?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _picV?.layer.masksToBounds = true
        
        
        _bottomOfPic = _picV!.frame.origin.y + _picV!.frame.height
        
        let _tapPic:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("_buttonTapHander:"))
        _picV?.addGestureRecognizer(_tapPic)
        
        
        
        _albumTitle_labelV = UIView(frame: CGRect(x: _gap, y: _bottomOfPic-30, width: _defaultSize!.width-2*_gap-2, height: 30))
        
        _albumTitle_labelV?.backgroundColor = UIColor(white: 0, alpha: 0.8)
        _albumTitle_labelV?.userInteractionEnabled=false
        _albumTitle_label = UITextView(frame: CGRect(x: 15+_gap, y: 8, width: _defaultSize!.width-2*_gap, height: 12))
        _albumTitle_label?.pagingEnabled=false
        _albumTitle_label?.textContainer.lineFragmentPadding=0
        _albumTitle_label?.textContainerInset = UIEdgeInsetsZero
        _albumTitle_label?.backgroundColor = UIColor.clearColor()
        _albumTitle_label?.editable=false
        _albumTitle_label?.selectable=false
        _albumTitle_label?.userInteractionEnabled=false
        
        _albumTitle_label?.font = UIFont.boldSystemFontOfSize(17)
        
        //_albumTitle_label?.backgroundColor = UIColor.clearColor()
        _albumTitle_label?.textColor = UIColor.whiteColor()
        
        
        _description = UILabel(frame: CGRect(x: _gap+10, y: _bottomOfPic, width: _defaultSize!.width-2*_gap-2*10, height: 70))
//        _description?.textContainerInset = UIEdgeInsetsZero
//        _description?.textContainer.lineFragmentPadding=0
//        _description?.editable=false
//        _description?.textColor = UIColor.blackColor()
//        _description?.selectable=false
        _description?.numberOfLines = 2
        _description?.font = UIFont.systemFontOfSize(14)
        
        
        _bgV = UIView(frame: CGRect(x: _gap, y: _gap, width: _picV!.frame.width, height: _picV!.frame.height+_gap+55+65))
        _bgV?.layer.cornerRadius = 5
        _bgV?.layer.borderColor = UIColor(white: 0.5, alpha: 1).CGColor
        _bgV?.layer.borderWidth=0.5
        _bgV?.backgroundColor=UIColor.whiteColor()
        
        self.addSubview(_bgV!)
        
        
        self.addSubview(_picV!)
        
        
        self.addSubview(_userImg!)
        self.addSubview(_userName_label!)
        self.addSubview(_updateTime_label!)
        self.addSubview(_albumTitle_labelV!)
        self.addSubview(_description!)
        
        
        
        
//        self.addSubview(_toolsPanel!)
//        self.addSubview(_commentsPanel!)
        
        
        _albumTitle_labelV?.addSubview(_albumTitle_label!)
        
        
        
        _setuped=true
        
        
    }
    
    //-------------------------调整布局-----------------
    
    func _refreshView(){
        _delegate?._resized(_indexId, __height:_bgV!.frame.height+_gap)
    }
    
    
    
    
    ///-------------------评论-----------------------------
    
    
    
    
    
    func commentString(_commentDict:NSDictionary) -> NSAttributedString {
        var boldFont = UIFont.boldSystemFontOfSize(14)
        
        var boldAttr = [NSFontAttributeName: boldFont]
        //let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),
        //   NSBackgroundColorAttributeName : UIColor.whiteColor()]
        let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),NSFontAttributeName: UIFont.systemFontOfSize(14)]
        
        var attrString: NSAttributedString = linkString(_commentDict.objectForKey("from_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("from_userId") as! String))
        
        var astr:NSMutableAttributedString = NSMutableAttributedString()
        astr.appendAttributedString(attrString)
        
        if _commentDict.objectForKey("to_userName") == nil || _commentDict.objectForKey("to_userName") as! String == "" {
            
        }else{
            attrString = NSAttributedString(string: "回复", attributes:normalAttr)
            astr.appendAttributedString(attrString)
            astr.appendAttributedString(linkString(_commentDict.objectForKey("to_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("to_userId") as! String)))
        }
        attrString = NSAttributedString(string: ": ", attributes:normalAttr)
        astr.appendAttributedString(attrString)
        attrString = NSAttributedString(string: _commentDict.objectForKey("comment") as! String, attributes:normalAttr)
        astr.appendAttributedString(attrString)
        return astr
    }
    func linkString(string:String, withURLString:String) -> NSAttributedString {
        var attrString = NSMutableAttributedString(string: string )
        // the entire string
        var range:NSRange = NSMakeRange(0, attrString.length)
        attrString.beginEditing()
        attrString.addAttribute(NSFontAttributeName, value:UIFont.systemFontOfSize(14, weight: 0.1), range:range)
        attrString.addAttribute(NSLinkAttributeName, value:withURLString, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1), range:range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        attrString.endEditing()
        return attrString
    }
    
    //-----文字链接代理
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        var _action:String = URL.scheme!
        println(_action)
        switch _action{
        case "user":
            let _str:String = URL.absoluteString!
            let _userId:NSString =  (_str as NSString).substringFromIndex(5)
            _delegate?._viewUser(_userId as String)
        case "moreComment":
            //println("hahahah")
            _delegate?._moreComment(_indexId)
        case "moreLike":
            _delegate?._moreLike(_indexId)
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
        self.superview?.removeGestureRecognizer(_tapC!)
    }
    //-------点赞人
    func _setLikes(__likes:NSArray,__allNum:Int){
        var _attrStr:NSMutableAttributedString = NSMutableAttributedString(string: "")
        if __allNum > 10{
            _attrStr = NSMutableAttributedString(attributedString: linkString(String(__allNum)+"个赞", withURLString:"moreLike:"))
        }else{
            var _lineLength:Int=0
            let _maxNum:Int = Int(_defaultSize!.width/5)
            //println(_maxNum)
            
            for var i:Int = 0; i < __likes.count ; ++i{
                if i>0 {
                    _attrStr.appendAttributedString(NSAttributedString(string: ", "))
                }
                
                let _likeDict = __likes.objectAtIndex(i) as! NSDictionary
                
                let _addingStr:String = _likeDict.objectForKey("userName") as! String
                
                let _addingLength:Int = _addingStr.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)
                
                if (_addingLength+_lineLength)>_maxNum{
                    //_attrStr.appendAttributedString(NSMutableAttributedString(string: "\n"))
                    _lineLength = _addingLength
                }else{
                    _lineLength = _lineLength + _addingLength
                }
                
                var attrString: NSAttributedString = linkString(_addingStr,withURLString: "user:"+(_likeDict.objectForKey("userId") as! String))
                _attrStr.appendAttributedString(attrString)
            }
            
        }
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        // paragraphStyle.headIndent = 50
        paragraphStyle.firstLineHeadIndent = 20
        _attrStr.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, _attrStr.length))
       
        //_likeTextView?.selectable=false
        //_likeTextView?.bounces=false
        //_likeTextView?.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    }
    
    //-----－－－－－－－－－－－按钮侦听
    
    
    func buttonAction(__button:UIButton){
        switch __button{
        case _btn_like:
            _delegate?._buttonAction("like", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_comment:
            _delegate?._buttonAction("comment", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_share:
            _delegate?._buttonAction("share", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_collect:
            _delegate?._buttonAction("collect", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
       
            
        default:
            println("")
        }
    }
    
    
    
    
    //------------------
    
    
    
    func _setDescription(__str:String){
        _description?.text=__str
    }
    func _setAlbumTitle(__str:String){
        if __str==""{
            //_albumTitle_label?.hidden=true
            //_albumTitle_labelV?.hidden=true
            _albumTitle_label?.text="未命名图册"
        }else{
            _albumTitle_label?.text=__str
            
        }
        
        _albumTitle_label?.hidden=false
        _albumTitle_labelV?.hidden=false
        
        
        
        let _size:CGSize = _albumTitle_label!.sizeThatFits(CGSize(width: _defaultSize!.width-2*_gap-2*10-1, height: CGFloat.max))
        
        _albumTitle_label?.frame = CGRect(x: 10, y: 6, width: _size.width, height: _size.height)
        _albumTitle_labelV?.frame = CGRect(x: _gap+1, y: _bottomOfPic-_size.height-12, width: _defaultSize!.width-2*_gap-2, height: _size.height+12)
        
    }
    func _setUserName(__str:String){
        _userName_label?.text=__str
    }
    func _setUpdateTime(__str:String){
        _updateTime_label?.text=__str
    }
    func _setUserImge(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: { (__dict) -> Void in
           // self._refreshView()
        })
    }
    
    func _setPic(__pic:NSDictionary){
        //println(__pic)
        //  _pic?.image = UIImage(named: __pic.objectForKey("url") as! String)
        _picV?._setPic(__pic, __block: { (__dict) -> Void in
            self._refreshView()
        })
    }
    
    func _setPics(__pics:NSArray){
        
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




