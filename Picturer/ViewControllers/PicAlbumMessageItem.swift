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
    func _viewUser(__userId:String)
    func _moreLike(__indexId:Int)
    func _buttonAction(__action:String,__dict:NSDictionary)
}


class PicAlbumMessageItem:  UITableViewCell,UITextViewDelegate{
    
    var _indexId:Int = 0
    var _indexString:String?
    
    var _type:String = "album" // pics
    
    var _user:NSDictionary?
    var _setuped:Bool = false
    var _picV:PicView?
    var _pic:UIImageView?
    var _userImg:PicView?
    var _userName_label:UILabel?
    var _updateTime_label:UILabel?
    var _albumTitle_labelV:UIView?
    var _albumTitle_label:UILabel?
    var _description:UITextView?
    
    var _toolsPanel:UIView?
    var _likeTextView:UITextView?
    var _toolsButtonPanel:UIView?
    var _toolsButtonPanel_container:UIView?
    var _toolsBtnToX:CGFloat?
    var _toolsBtnToW:CGFloat?
    var _toolsOpenButton:UIButton?
    
    var _likeIcon:UIImageView?
    
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
    

    var _tapC:UITapGestureRecognizer?
    
    
    var _toolsBarIsOpened:Bool=false
    
    
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
        
        
        _description = UITextView()
        _description?.editable=false
        
        
        
        
        _likeTextView = UITextView()
        _likeTextView?.backgroundColor = UIColor.clearColor()
        _likeTextView?.delegate=self
        _likeTextView?.editable=false
        _likeTextView?.tintColor = UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1)
        
        
        _likeIcon = UIImageView(frame: CGRect(x: 12, y: 15, width: 0.6*28, height: 0.6*24))
        _likeIcon?.image = UIImage(named: "like")
        
        
        
        
        
        
        
        
        _toolsOpenButton = UIButton(frame: CGRect(x: _defaultSize!.width-0.6*57-10, y: 10, width: 0.6*57, height: 0.6*31))
        _toolsOpenButton?.setImage(UIImage(named: "toolsBtn"), forState: UIControlState.Normal)
        _toolsOpenButton?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //----工具条
        let _toolsGap:CGFloat = (_defaultSize!.width-80)/4
        switch _type{
            case "album":
                _btn_like = UIButton(frame: CGRect(x: 0, y: 0, width: _toolsGap, height: 40))
                _btn_like?.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_like?.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_like?.setTitle("赞", forState: UIControlState.Normal)
                _btn_like?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                
                _btn_comment = UIButton(frame: CGRect(x: _toolsGap, y: 0, width: _toolsGap, height: 40))
                _btn_comment?.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_comment?.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_comment?.setTitle("评论", forState: UIControlState.Normal)
                _btn_comment?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                _btn_share = UIButton(frame: CGRect(x: 2*_toolsGap, y: 0, width: _toolsGap, height: 40))
                _btn_share?.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_share?.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_share?.setTitle("分享", forState: UIControlState.Normal)
                _btn_share?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                _btn_collect = UIButton(frame: CGRect(x: 3*_toolsGap, y: 0, width: _toolsGap, height: 40))
                _btn_collect?.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_collect?.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_collect?.setTitle("收藏", forState: UIControlState.Normal)
                _btn_collect?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                _toolsBtnToX = _defaultSize!.width-4*_toolsGap-45
                _toolsBtnToW = 4*_toolsGap
                
                _toolsButtonPanel_container = UIView(frame: CGRect(x: _defaultSize!.width-45, y: 0, width:0, height: 40))
                _toolsButtonPanel_container?.backgroundColor = UIColor.clearColor()
                _toolsButtonPanel_container?.clipsToBounds=true
                
                
                _toolsButtonPanel = UIView(frame: CGRect(x: 0, y: 0, width: 4*_toolsGap, height: 40))
                _toolsButtonPanel?.layer.masksToBounds=true
                _toolsButtonPanel?.layer.cornerRadius = 5
                _toolsButtonPanel?.clipsToBounds=true
                
                _toolsButtonPanel?.backgroundColor = UIColor.darkGrayColor()
                _toolsButtonPanel?.addSubview(_btn_like!)
                _toolsButtonPanel?.addSubview(_btn_comment!)
                _toolsButtonPanel?.addSubview(_btn_share!)
                _toolsButtonPanel?.addSubview(_btn_collect!)
            
            
                _toolsButtonPanel_container?.addSubview(_toolsButtonPanel!)
            
            
        default:
            println("")
        }
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("_tapHander:"))
        
        
        _toolsPanel = UIView(frame: CGRect(x: 0, y: 50+_picV!.frame.height, width: _defaultSize!.width, height: 36))
        _toolsPanel?.addSubview(_likeTextView!)
        _toolsPanel?.addSubview(_likeIcon!)
        _toolsPanel?.addSubview(_toolsOpenButton!)
        _toolsPanel?.addSubview(_toolsButtonPanel_container!)
        
        
        
        
        
        _commentsPanel = UIView(frame: CGRect(x: 0, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width, height: 36))
        _commentsPanel?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        _attributeStr = NSMutableAttributedString()
        
        _commentText = UITextView()
        _commentText!.attributedText = _attributeStr!
        _commentText?.backgroundColor =  UIColor.clearColor()
        _commentText!.delegate=self
        _commentText!.attributedText = _attributeStr!
        _commentText!.selectable=true
        _commentText!.editable=false
        _commentText?.userInteractionEnabled=true
        
        _moreCommentText = UITextView()
        _moreCommentText?.backgroundColor =  UIColor.clearColor()
        _moreCommentText?.tintColor = UIColor.darkGrayColor()
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
        self.addSubview(_description!)
        self.addSubview(_toolsPanel!)
        self.addSubview(_commentsPanel!)
        
        
        _albumTitle_labelV?.addSubview(_albumTitle_label!)
        
        
        _setuped=true
    }
    
    //-------------------------调整布局-----------------
    
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
        
        
        var _desH:CGFloat = 0
        if _description!.text == ""{
            
        }else{
            _desH = _description!.contentSize.height
        }
        
        _description?.frame = CGRect(x: 10, y: 50+_picV!.frame.height+10, width: _defaultSize!.width-20, height: _desH)
        
        
        
        _likeTextView?.frame = CGRect(x: 10, y: 5, width: _defaultSize!.width-10-28, height: _likeTextView!.contentSize.height)
        
        
        _toolsPanel!.frame = CGRect(x: 0, y: 50+_picV!.frame.height+_desH+5, width: _defaultSize!.width, height: _likeTextView!.contentSize.height+15)
        
         _commentText?.frame = CGRect(x: 5, y: 5, width: _defaultSize!.width-30, height: _commentText!.contentSize.height)
        
        
        var _moreComentH:CGFloat = 0
        
        if _moreCommentText?.text == ""{
        
        }else{
            _moreComentH = _moreCommentText!.contentSize.height
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
            _moreCommentText?.attributedText = linkString("查看全部"+String(_n)+"条评论",withURLString:"moreComment:")
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
        attrString.addAttribute(NSLinkAttributeName, value:withURLString, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.blueColor(), range:range)
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
            println("hahahah")
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
    
    
    
    
    
    
    
    
    //---------------------------------工具条------------------------
    
    func _openPanel(__set:Bool){
        _toolsBarIsOpened=__set
         UIView.beginAnimations("toolsOpen", context: nil)
            if __set{
                _toolsButtonPanel_container?.frame = CGRect(x: _toolsBtnToX!, y: 0, width:_toolsBtnToW!, height: 40)
                
            }else{
                _toolsButtonPanel_container?.frame = CGRect(x: _defaultSize!.width-45, y: 0, width:0, height: 40)
            }
            UIView.commitAnimations()
    }
    
    func _tapHander(__tap:UITapGestureRecognizer){
        
        _openPanel(false)
        self.superview?.removeGestureRecognizer(_tapC!)
        //self.window?.removeGestureRecognizer(_tapC!)
        //self.removeGestureRecognizer(_tapC!)
    }
    
    override func removeFromSuperview() {
        print("out")
        self.window?.removeGestureRecognizer(_tapC!)
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
        _likeTextView!.attributedText = _attrStr
        //_likeTextView?.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    }
    
    //-----－－－－－－－－－－－按钮侦听
    
    
    func buttonAction(__button:UIButton){
        switch __button{
        case _btn_like!:
            _delegate?._buttonAction("like", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_comment!:
            _delegate?._buttonAction("comment", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_share!:
            _delegate?._buttonAction("share", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_collect!:
            _delegate?._buttonAction("collect", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _toolsOpenButton!:
            if _toolsBarIsOpened{
                
                _openPanel(false)
            }else{
                
                _openPanel(true)
                self.superview?.addGestureRecognizer(_tapC!)
            }
            
        default:
            println("")
        }
    }
    
    //------------------
    
    
    func _setDescription(__str:String){
        _description?.text=__str
    }
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




