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
    func _viewAlbum(__albumIndex:Int)
    func _viewPicsAtIndex(__array:NSArray,__index:Int)
    func _moreLike(__indexId:Int)
    func _buttonAction(__action:String,__dict:NSDictionary)
}


class PicAlbumMessageItem:  UITableViewCell,UITextViewDelegate{
    var _picsW:CGFloat = 0
    let _gapForPic:CGFloat = 2
    
    var _bottomOfPic:CGFloat = 0 //---到图片底部的位置
    
    let _gap:CGFloat = 15
    var _indexId:Int = 0
    var _indexString:String?
    
    var _type:String = "album" // pics
    
    var _user:NSDictionary?
    var _userId:String?
    var _setuped:Bool = false
    var _picV:PicView? = PicView()
    //var _pic:UIImageView?
   
    var _pics:NSArray?
    var _picsContainer:UIView = UIView()
    var _userImg:PicView?
    var _userName_label:UILabel?
    var _updateTime_label:UILabel?
    var _albumTitle_labelV:UIView?
    var _albumTitle_label:UITextView?
    var _description:UITextView?
    
    var _toolsPanel:UIView?
    var _likeTextView:UITextView?
    var _toolsButtonPanel:UIView?
    var _toolsButtonPanel_container:UIView?
    var _toolsBtnToX:CGFloat?
    var _toolsBtnToW:CGFloat?
    var _toolsOpenButton:UIButton?
    
    var _likeIcon:UIImageView?
    
    var _btn_like:UIButton = UIButton()
    var _btn_comment:UIButton = UIButton()
    var _btn_share:UIButton = UIButton()
    var _btn_collect:UIButton = UIButton()
    
    var _delegate:PicAlbumMessageItem_delegate?
    
    var _cellH:CGFloat?
    
    var _defaultSize:CGSize?
    
    var _commentsPanel:UIView?
    var _commentText:UITextView?
    var _moreCommentText:UITextView?
    
    var _attributeStr:NSMutableAttributedString?
    

    var _tapC:UITapGestureRecognizer?
    
    var _buttonTap:UITapGestureRecognizer?
    
    
    var _toolsBarIsOpened:Bool=false
    
    var _bgV:UIView?
    var _lineBg:UIView?
    
    
    
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
        
        _bgV = UIView()
        _bgV?.backgroundColor=UIColor.whiteColor()
        
        _lineBg = UIView()
        _lineBg?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        self.addSubview(_bgV!)
        self.addSubview(_lineBg!)
        
        
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("_tapHander:"))
        _buttonTap = UITapGestureRecognizer(target: self, action: Selector("_buttonTapHander:"))
        //println(_defaultSize!.width)
        
        
        
        _userImg = PicView(frame: CGRect(x: 15, y: 6.5, width: 32, height: 32))
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?.layer.masksToBounds=true
        _userImg?.layer.cornerRadius = 16
        
        _userImg?.addGestureRecognizer(_buttonTap!)
        
        
        _userName_label = UILabel(frame: CGRect(x: 59, y: 17, width: 200, height: 12))
        _userName_label?.font = UIFont.boldSystemFontOfSize(14)
        _userName_label?.textColor = UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1)
        
        _updateTime_label = UILabel(frame: CGRect(x: _defaultSize!.width-155, y: 17, width: 140, height: 12))
        
        _updateTime_label?.textAlignment = NSTextAlignment.Right
        _updateTime_label?.font = UIFont.systemFontOfSize(12)
        
        
        
        
        _description = UITextView()
        _description?.textContainerInset = UIEdgeInsetsZero
        _description?.textContainer.lineFragmentPadding=0
        _description?.editable=false
        _description?.selectable=false
        _description?.font = UIFont.systemFontOfSize(14)
        
        _likeTextView = UITextView()
        _likeTextView?.font=UIFont.boldSystemFontOfSize(14)
        _likeTextView?.backgroundColor = UIColor.clearColor()
        _likeTextView?.delegate=self
        _likeTextView?.editable=false
        _likeTextView?.tintColor = UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1)
        
        
        _likeIcon = UIImageView(frame: CGRect(x: _gap, y: 15, width: 13.5, height: 12))
        _likeIcon?.image = UIImage(named: "like.png")
        
        
        
        
        
        
        
        
        _toolsOpenButton = UIButton(frame: CGRect(x: _defaultSize!.width-27.5-_gap, y: _gap, width: 27.5, height: 15))
        _toolsOpenButton?.setImage(UIImage(named: "toolsBtn.png"), forState: UIControlState.Normal)
        _toolsOpenButton?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //----工具条
        let _toolsGap:CGFloat = (_defaultSize!.width-80)/4
        _toolsButtonPanel = UIView()
        _toolsButtonPanel?.layer.masksToBounds=true
        _toolsButtonPanel?.layer.cornerRadius = 5
        _toolsButtonPanel?.clipsToBounds=true
       
        _toolsButtonPanel_container = UIView()
        _toolsButtonPanel_container?.backgroundColor = UIColor.clearColor()
        _toolsButtonPanel_container?.clipsToBounds=true
        
        _toolsButtonPanel_container?.addSubview(_toolsButtonPanel!)
        
        
        
        
        switch _type{
            case "album":
                _toolsButtonPanel!.frame = CGRect(x: 0, y: 0, width: 4*_toolsGap, height: 40)
                
                _btn_like = UIButton(frame: CGRect(x: 0, y: 0, width: _toolsGap, height: 40))
                _btn_like.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_like.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_like.setTitle("赞", forState: UIControlState.Normal)
                _btn_like.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                _btn_comment = UIButton(frame: CGRect(x: _toolsGap, y: 0, width: _toolsGap, height: 40))
                _btn_comment.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_comment.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_comment.setTitle("评论", forState: UIControlState.Normal)
                _btn_comment.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                _btn_share = UIButton(frame: CGRect(x: 2*_toolsGap, y: 0, width: _toolsGap, height: 40))
                _btn_share.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_share.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_share.setTitle("分享", forState: UIControlState.Normal)
                _btn_share.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                _btn_collect = UIButton(frame: CGRect(x: 3*_toolsGap, y: 0, width: _toolsGap, height: 40))
                _btn_collect.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_collect.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_collect.setTitle("收藏", forState: UIControlState.Normal)
                _btn_collect.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                _toolsBtnToX = _defaultSize!.width-4*_toolsGap-45
                _toolsBtnToW = 4*_toolsGap
                
                _toolsButtonPanel?.backgroundColor = UIColor.darkGrayColor()
                _toolsButtonPanel?.addSubview(_btn_like)
                _toolsButtonPanel?.addSubview(_btn_comment)
                _toolsButtonPanel?.addSubview(_btn_share)
                _toolsButtonPanel?.addSubview(_btn_collect)
        
            
            
                _picV = PicView(frame: CGRect(x: 0, y: 45, width: _defaultSize!.width, height: _defaultSize!.width))
                _picV?._setImage("noPic.png")
                _picV?.scrollEnabled=false
                _picV?.maximumZoomScale = 1
                _picV?.minimumZoomScale = 1
                _picV?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
                _picV?.layer.masksToBounds = true
                
                
                _bottomOfPic = _picV!.frame.origin.y + _picV!.frame.height
                
                let _tapPic:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("_buttonTapHander:"))
                _picV?.addGestureRecognizer(_tapPic)
            
                
                
                _albumTitle_labelV = UIView(frame: CGRect(x: 0, y: _bottomOfPic-30, width: _defaultSize!.width, height: 30))
                
                _albumTitle_labelV?.backgroundColor = UIColor(white: 0, alpha: 0.8)
                _albumTitle_labelV?.userInteractionEnabled=false
                _albumTitle_label = UITextView(frame: CGRect(x: 15, y: 8, width: _defaultSize!.width-2*_gap, height: 12))
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
                
                
                self.addSubview(_picV!)
            
            case "pics":
                
                
                _toolsButtonPanel!.frame = CGRect(x: 0, y: 0, width: 4*_toolsGap, height: 40)
                
                _btn_like = UIButton(frame: CGRect(x: 0, y: 0, width: _toolsGap, height: 40))
                _btn_like.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_like.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_like.setTitle("赞", forState: UIControlState.Normal)
                _btn_like.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                _btn_comment = UIButton(frame: CGRect(x: _toolsGap, y: 0, width: _toolsGap, height: 40))
                _btn_comment.titleLabel?.font = UIFont.systemFontOfSize(16, weight: 1)
                _btn_comment.titleLabel?.textAlignment = NSTextAlignment.Center
                _btn_comment.setTitle("评论", forState: UIControlState.Normal)
                _btn_comment.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                _btn_comment.backgroundColor = UIColor.clearColor()
                
                _toolsBtnToX = _defaultSize!.width-2*_toolsGap-45
                _toolsBtnToW = 2*_toolsGap
                
                _toolsButtonPanel?.backgroundColor = UIColor.darkGrayColor()
                _toolsButtonPanel?.addSubview(_btn_like)
                _toolsButtonPanel?.addSubview(_btn_comment)
                
                
                var _numOneLine:Int
                
                if _pics?.count == 1{
                    _picsW = _defaultSize!.width
                    _bottomOfPic = 45 + _picsW
                    _numOneLine = 1
                    
                }else if _pics?.count == 2{
                    _picsW = (_defaultSize!.width - _gapForPic)/2
                    _bottomOfPic = 45 + _picsW
                    _numOneLine = 2
                    
                }else{
                    _picsW = (_defaultSize!.width - 2*_gapForPic)/3
                    _bottomOfPic = 45 + (floor(CGFloat((_pics!.count-1)/3))+1)*(_picsW + _gapForPic)
                    _numOneLine = 3
                }
                
                for i in 0..._pics!.count-1{
                    var _p:PicView = PicView(frame: CGRect(x: CGFloat(i%_numOneLine)*(_picsW + _gapForPic), y: (floor(CGFloat(i/3)))*(_picsW + _gapForPic), width: _picsW, height: _picsW))
                    _p.maximumZoomScale=1
                    _p.minimumZoomScale=1
                    _p._imgView?.contentMode=UIViewContentMode.ScaleAspectFill
                    _p._id = i
                    //_p._setImage("noPic.png")
                    _p._setPic(_pics?.objectAtIndex(i) as! NSDictionary, __block: { (ok) -> Void in
                        //self._refreshView()
                    })
                    
                    let _tapPic:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("_buttonTapHander:"))
                    _p.addGestureRecognizer(_tapPic)
                    
                    _picsContainer.addSubview(_p)
                }
                //_picsContainer.backgroundColor = UIColor.redColor()
                _picsContainer.frame = CGRect(x: 0, y: 45, width: _defaultSize!.width, height: _bottomOfPic-45)
                
                
                _albumTitle_labelV = UIView(frame: CGRect(x: 0, y: _bottomOfPic+_gap, width: _defaultSize!.width, height: 30))
                
                _albumTitle_labelV?.backgroundColor = UIColor.clearColor()
                _albumTitle_labelV?.layer.borderWidth = 1
                _albumTitle_labelV?.layer.borderColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1).CGColor
                _albumTitle_labelV?.layer.cornerRadius = 5
                _albumTitle_labelV?.userInteractionEnabled=false
                _albumTitle_label = UITextView(frame: CGRect(x: 15, y: 8, width: _defaultSize!.width-2*_gap, height: 12))
                _albumTitle_label?.pagingEnabled=false
                _albumTitle_label?.textContainer.lineFragmentPadding=0
                _albumTitle_label?.textContainerInset = UIEdgeInsetsZero
                _albumTitle_label?.backgroundColor = UIColor.clearColor()
                _albumTitle_label?.editable=false
                _albumTitle_label?.selectable=false
                _albumTitle_label?.userInteractionEnabled=false
                
                _albumTitle_label?.font = UIFont.boldSystemFontOfSize(14)
                _albumTitle_label?.textColor = UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1)
                
                
                break
        default:
            println("")
        }
        
        
        
        _toolsPanel = UIView(frame: CGRect(x: 0, y: _bottomOfPic+5, width: _defaultSize!.width, height: 36))
        _toolsPanel?.addSubview(_likeTextView!)
        _toolsPanel?.addSubview(_likeIcon!)
        _toolsPanel?.addSubview(_toolsOpenButton!)
        _toolsPanel?.addSubview(_toolsButtonPanel_container!)
        
        _commentsPanel = UIView(frame: CGRect(x: 0, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width, height: 36))
        _commentsPanel?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        _attributeStr = NSMutableAttributedString()
        
        _commentText = UITextView()
        _commentText?.font = UIFont.systemFontOfSize(14)
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
        
        
        
        
        self.addSubview(_picsContainer)
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
        //_picV?.frame = CGRect(x: 0, y: 50, width: self.frame.width, height: _h)
        //_picV?._refreshView()
        
        //_albumTitle_labelV?.frame = CGRect(x: 0, y: 50+_picV!.frame.height-36, width: self.frame.width, height: 36)
        
        var _desH:CGFloat = 0
        
        
        if _type == "pics"{
            _desH = _albumTitle_labelV!.frame.height+_gap
        }else{
            if _description!.text == ""{
                
            }else{
                let size:CGSize = _description!.sizeThatFits(CGSize(width: _defaultSize!.width-_gap*2, height: CGFloat.max))
                _desH = size.height+_gap
            }
            
            _description?.frame = CGRect(x: _gap, y: _bottomOfPic+_gap, width: _defaultSize!.width-_gap*2, height: _desH)
        }
        
        
        _likeTextView?.frame = CGRect(x: 10, y: 5, width: _defaultSize!.width-10-28, height: _likeTextView!.contentSize.height)
        
        
        _toolsPanel!.frame = CGRect(x: 0, y: _bottomOfPic+_desH, width: _defaultSize!.width, height: _likeTextView!.contentSize.height+15)
        
        _commentText?.frame = CGRect(x: 5, y: 5, width: _defaultSize!.width-30, height: _commentText!.contentSize.height)
        
        
        var _moreComentH:CGFloat = 0
        
        if _moreCommentText?.text == ""{
        
        }else{
            _moreComentH = _moreCommentText!.contentSize.height
        }
        _moreCommentText?.frame = CGRect(x: 5, y: _commentText!.contentSize.height-8+5, width: _defaultSize!.width-30, height: _moreComentH)
        
        _commentsPanel!.frame = CGRect(x: _gap, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width-2*_gap, height: _moreCommentText!.frame.origin.y+_moreCommentText!.frame.height+10)
        
        
        _bgV!.frame = CGRect(x: 0, y: 0, width: _defaultSize!.width, height:_commentsPanel!.frame.origin.y+_commentsPanel!.frame.height+_gap )
        _lineBg!.frame = CGRect(x: 0, y: _bgV!.frame.height, width: _defaultSize!.width, height: 0.5)
        
        //self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: _h+40)
        
        
        
        _delegate?._resized(_indexId, __height:_bgV!.frame.height+_gap)
        
        
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
            let _commentDict:NSDictionary = __comments.objectAtIndex(__comments.count - 1 - i) as! NSDictionary
            _attributeStr?.appendAttributedString(commentString(_commentDict))
            if i>1 {
                break
            }
        }
        
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        _attributeStr?.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, _attributeStr!.length))
        
        _commentText!.attributedText = _attributeStr!
        
        
        _commentText?.linkTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1)]
       
        if _n>3{
            _moreCommentText?.attributedText = linkString("查看全部"+String(_n)+"条评论",withURLString:"moreComment:")
        }else{
            _moreCommentText?.text = ""
        }
        
        
    }
    
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
    
    
    //----点击动作
    func _tapHander(__tap:UITapGestureRecognizer){
        
        _openPanel(false)
        self.superview?.removeGestureRecognizer(_tapC!)
        //self.window?.removeGestureRecognizer(_tapC!)
        //self.removeGestureRecognizer(_tapC!)
    }
    
    func _buttonTapHander(__tap:UITapGestureRecognizer){
        switch __tap.view!{
        case _userImg!:
            _delegate?._viewUser(_userId!)
            return
        case _picV!:
            _delegate?._viewAlbum(_indexId)
        default:
            let _picV:PicView = __tap.view! as! PicView
            
            _delegate?._viewPicsAtIndex(_pics!, __index: _picV._id)
            
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
        _likeTextView!.attributedText = _attrStr
        _likeTextView?.editable=false
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
        if __str==""{
            //_albumTitle_label?.hidden=true
            //_albumTitle_labelV?.hidden=true
            _albumTitle_label?.text="未命名图册"
        }else{
            _albumTitle_label?.text=__str
            
        }
     
        _albumTitle_label?.hidden=false
        _albumTitle_labelV?.hidden=false
        
        
        
        let _size:CGSize = _albumTitle_label!.sizeThatFits(CGSize(width: _defaultSize!.width-2*_gap, height: CGFloat.max))
        
        switch _type{
            case "album":
                _albumTitle_label?.frame = CGRect(x: _gap, y: 6, width: _size.width, height: _size.height)
                _albumTitle_labelV?.frame = CGRect(x: 0, y: _bottomOfPic-_size.height-12, width: _defaultSize!.width, height: _size.height+12)
            break
            case "pics":
                _albumTitle_label?.frame = CGRect(x: 5, y: 3.3, width: _size.width, height: _size.height)
                _albumTitle_labelV?.frame = CGRect(x: _gap, y: _bottomOfPic+12, width: _size.width+5*2, height: _size.height+3.3*2)
                
            break
        default:
            break
        }
        
    }
    func _setUserName(__str:String){
        _userName_label?.text=__str
    }
    func _setUpdateTime(__str:String){
        _updateTime_label?.text=__str
    }
    func _setUserImge(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: { (__dict) -> Void in
            self._refreshView()
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




