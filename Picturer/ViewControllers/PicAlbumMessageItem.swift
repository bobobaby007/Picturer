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
    
    var _alerter:MyAlerter?
    
    var _bottomOfPic:CGFloat = 0 //---到图片底部的位置
    
    let _gap:CGFloat = 15
    var _indexId:Int = 0
    var _indexString:String?
    
    var _type:String = "myHome" //  myHome/status/ 判断类型 主页/动态
    
    var _user:NSDictionary?
    var _userId:String?
    var _setuped:Bool = false
    var _picV:PicView? = PicView()
    //var _pic:UIImageView?
   
    var _userImg:PicView?
    var _userBtn:UIButton?
    var _updateTime_label:UILabel?
    var _albumTitle_labelV:UIView?
    var _albumTitle_label:UITextView?
    var _description:UITextView?
    
    var _toolsPanel:UIView?
    
    var _toolsButtonPanel:UIView?
   
    var _toolsBtnToX:CGFloat?
    var _toolsBtnToW:CGFloat?
    var _toolsOpenButton:UIButton?
    
    var _likeIcon:UIImageView?
    var _likeNumLable:UILabel?
    
    var _btn_moreAction:UIButton?
    
    var _titleStr:String?
    
    
    var _btn_like:UIButton = UIButton()
    var _btn_comment:UIButton = UIButton()
    var _btn_collect:UIButton = UIButton()
    
    weak var _delegate:PicAlbumMessageItem_delegate?
    
    var _cellH:CGFloat?
    
    var _defaultSize:CGSize?
    
    var _commentsPanel:UIView?
    var _commentText:UITextView?
    var _moreCommentText:UITextView?
    
    var _attributeStr:NSMutableAttributedString?
    

    var _tapC:UITapGestureRecognizer?
    
    var _buttonTap:UITapGestureRecognizer?
    var _toolsGap:CGFloat = 0
    
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
        _userBtn?.setTitleColor(Config._color_social_blue, forState: UIControlState.Normal)
        
        _updateTime_label = UILabel(frame: CGRect(x: 59, y: 26, width: 140, height: 12))
        _updateTime_label?.textColor = Config._color_gray_time
        _updateTime_label?.textAlignment = NSTextAlignment.Left
        _updateTime_label?.font = Config._font_social_time
        
        _btn_moreAction = UIButton(frame: CGRect(x: _defaultSize!.width-35, y: 12.5, width: 20, height: 20))
        //_btn_moreAction?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_moreAction?.setImage(UIImage(named: "moreAction_Social"), forState: UIControlState.Normal)
        _btn_moreAction?.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _description = UITextView()
        _description?.textContainerInset =  UIEdgeInsetsMake(-3, 0, 0, 0)  //{{-10,-5},{0,0}} // UIEdgeInsetsZero
        _description?.textContainer.lineFragmentPadding = 0
        _description?.textAlignment = NSTextAlignment.Left
        //_description?.backgroundColor = UIColor.grayColor()
        _description?.editable=false
        _description?.selectable=false
        _description?.font = Config._font_social_album_description
        _description?.textColor = Config._color_social_gray
        
        
        
        
        
        _likeNumLable = UILabel(frame: CGRect(x: _defaultSize!.width - 21, y: 0, width: 12, height: 17))
        
        _likeNumLable?.textAlignment = NSTextAlignment.Right
        //_likeNumLable?.contentMode = UIViewContentMode.TopLeft
        _likeNumLable?.textColor = Config._color_social_blue
        _likeNumLable?.font = Config._font_social_likeNum
        
        _likeIcon = UIImageView(frame: CGRect(x: _defaultSize!.width - 13 - Config._gap, y: 0, width: 13, height: 20))
        _likeIcon?.image = UIImage(named: "like_sign.png")
        
        
        _toolsOpenButton = UIButton(frame: CGRect(x: _defaultSize!.width-27.5-_gap, y: _gap, width: 27.5, height: 15))
        _toolsOpenButton?.setImage(UIImage(named: "toolsBtn.png"), forState: UIControlState.Normal)
        _toolsOpenButton?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //----工具条
        _toolsGap = (_defaultSize!.width-80)/4
        _toolsButtonPanel = UIView()
        
        switch _type{
            case "myHome":
                _setUpForMyHome()
            case "status":
                _setUpForStatus()
                break
        default:
            print("")
        }
        
        //-----喜欢、评论、工具条
        
        _toolsPanel = UIView(frame: CGRect(x: 0, y: _bottomOfPic+5, width: _defaultSize!.width, height: 36))
        
        _toolsPanel?.addSubview(_likeIcon!)
        _toolsPanel?.addSubview(_likeNumLable!)
       
        
        _toolsPanel?.addSubview(_toolsButtonPanel!)
        
        
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
        
        
        
        
       
        self.addSubview(_userImg!)
        self.addSubview(_btn_moreAction!)
        self.addSubview(_userBtn!)
        self.addSubview(_updateTime_label!)
        self.addSubview(_albumTitle_labelV!)
        self.addSubview(_description!)
        self.addSubview(_toolsPanel!)
        self.addSubview(_commentsPanel!)
        
        
        _albumTitle_labelV?.addSubview(_albumTitle_label!)
        
        
        
        _setuped=true
        
        
    }
    func _setUpForMyHome(){
        _toolsButtonPanel!.frame = CGRect(x: 0, y: 0, width: 4*_toolsGap, height: 35)
        
        
        _btn_like = UIButton(frame: CGRect(x: Config._gap, y: 0, width: 23, height: 20))
        _btn_like.setImage(UIImage(named: "like_off"), forState: UIControlState.Normal)
        _btn_like.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_comment = UIButton(frame: CGRect(x: Config._gap+44, y: 0, width: 26, height: 20))
        _btn_comment.setImage(UIImage(named: "message_icon"), forState: UIControlState.Normal)
        _btn_comment.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_collect = UIButton(frame: CGRect(x: Config._gap+93, y: 0, width: 22, height: 20))
        _btn_collect.setImage(UIImage(named: "collect_off"), forState: UIControlState.Normal)
        _btn_collect.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _toolsBtnToX = _defaultSize!.width-4*_toolsGap-45
        _toolsBtnToW = 4*_toolsGap
        
        _toolsButtonPanel?.backgroundColor = UIColor.clearColor()
        _toolsButtonPanel?.addSubview(_btn_like)
        _toolsButtonPanel?.addSubview(_btn_comment)
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
        
        _albumTitle_labelV?.backgroundColor = Config._color_social_albumTitle_over
        _albumTitle_labelV?.userInteractionEnabled=false
        _albumTitle_label = UITextView(frame: CGRect(x: 15, y: 8, width: _defaultSize!.width-2*_gap, height: 12))
        
        _albumTitle_label?.pagingEnabled=false
        _albumTitle_label?.textContainer.lineFragmentPadding=0
        _albumTitle_label?.textContainerInset = UIEdgeInsetsZero
        _albumTitle_label?.backgroundColor = UIColor.clearColor()
        _albumTitle_label?.editable=false
        _albumTitle_label?.selectable=false
        _albumTitle_label?.userInteractionEnabled=false
        
        _albumTitle_label?.textColor = UIColor.whiteColor()
        _albumTitle_label?.font = Config._font_social_album_title
        _albumTitle_label?.textColor = UIColor.whiteColor()
        
        
        self.addSubview(_picV!)
    }
    func _setUpForStatus(){
        _toolsButtonPanel!.frame = CGRect(x: 0, y: 0, width: 4*_toolsGap, height: 35)
        
        
        _btn_like = UIButton(frame: CGRect(x: Config._gap, y: 0, width: 23, height: 20))
        _btn_like.setImage(UIImage(named: "like_off"), forState: UIControlState.Normal)
        _btn_like.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_comment = UIButton(frame: CGRect(x: 44, y: 0, width: 26, height: 20))
        _btn_comment.setImage(UIImage(named: "message_icon"), forState: UIControlState.Normal)
        _btn_comment.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_collect = UIButton(frame: CGRect(x: 93, y: 0, width: 22, height: 20))
        _btn_collect.setImage(UIImage(named: "collect_off"), forState: UIControlState.Normal)
        _btn_collect.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)

        
        _toolsBtnToX = _defaultSize!.width-4*_toolsGap-45
        _toolsBtnToW = 4*_toolsGap
        
        _toolsButtonPanel?.backgroundColor = UIColor.clearColor()
        _toolsButtonPanel?.addSubview(_btn_like)
        _toolsButtonPanel?.addSubview(_btn_comment)
        //_toolsButtonPanel?.addSubview(_btn_collect)
        
        
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
        _albumTitle_labelV = UIView(frame: CGRect(x: 0, y: _bottomOfPic, width: _defaultSize!.width, height: 20))
        _albumTitle_labelV?.backgroundColor = UIColor.clearColor()
        _albumTitle_labelV?.userInteractionEnabled=false
        _albumTitle_label = UITextView(frame: CGRect(x: 15, y: 0, width: _defaultSize!.width-2*_gap, height: 12))
        _albumTitle_label?.textColor = UIColor.whiteColor()
        _albumTitle_label?.font = Config._font_social_button_2
        
        _albumTitle_label?.pagingEnabled=false
        _albumTitle_label?.textContainer.lineFragmentPadding=0
        _albumTitle_label?.textContainerInset = UIEdgeInsetsZero
        _albumTitle_label?.backgroundColor = UIColor.clearColor()
        _albumTitle_label?.editable=false
        _albumTitle_label?.selectable=false
        _albumTitle_label?.userInteractionEnabled=false
        
        self.addSubview(_picV!)
    }
    
    
    //-------------------------调整布局-----------------
    
    func _refreshView(){
        
        var _desH:CGFloat = 0
        
        
        if _type == "pics"{
            _desH = _albumTitle_labelV!.frame.height+_gap
            //---暂时去掉标题
            _desH = 0
            _albumTitle_labelV?.hidden=true
            _albumTitle_label?.hidden = true
            //---
        }else{
            if _description!.text == ""{
                
            }else{
                let size:CGSize = _description!.sizeThatFits(CGSize(width: _defaultSize!.width-_gap*2, height: CGFloat.max))
                _desH = size.height+_gap
            }
            
            
        }
        
        
        
        
        switch _type{
            case "myHome":
                _toolsPanel!.frame = CGRect(x: 0, y: _bottomOfPic+_desH+_gap, width: _defaultSize!.width, height: 20)
                _description?.frame = CGRect(x: _gap, y: _bottomOfPic+_gap-1, width: _defaultSize!.width-_gap*2, height: _desH)
            break
            case "status":
                _toolsPanel?.frame.origin.y = _albumTitle_labelV!.frame.origin.y+_albumTitle_labelV!.frame.height+_gap
                _description?.frame = CGRect(x: _gap, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width-_gap*2, height: _desH)
            break
        default:
            break
        }
        
        
        
        _commentText?.frame = CGRect(x: 5, y: 5, width: _defaultSize!.width-30, height: _commentText!.contentSize.height)
        
        
        var _moreComentH:CGFloat = 0
        
        if _moreCommentText?.text == ""{
        
        }else{
            _moreComentH = _moreCommentText!.contentSize.height
        }
        _moreCommentText?.frame = CGRect(x: 5, y: _commentText!.contentSize.height-8+5, width: _defaultSize!.width-30, height: _moreComentH)
        
        var _bgH:CGFloat = 0
        
        
        _bgH = _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height+_gap
        

        
        
        if _commentText?.text==""{
        _commentsPanel!.frame = CGRect(x: _gap, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width-2*_gap, height: 0)
        }else{
            _commentsPanel!.frame = CGRect(x: _gap, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height-5, width: _defaultSize!.width-2*_gap, height: _moreCommentText!.frame.origin.y+_moreCommentText!.frame.height+10)
            _bgH = _commentsPanel!.frame.origin.y+_commentsPanel!.frame.height+_gap
        }
        
        
        _bgV!.frame = CGRect(x: 0, y: 0, width: _defaultSize!.width, height:_bgH )
        
        _lineBg!.frame = CGRect(x: 0, y: _bgV!.frame.height, width: _defaultSize!.width, height: 0.5)
        
        //self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: _h+40)
        
        
        _delegate?._resized(_indexId, __height:_bgV!.frame.height+_gap)
        
        
    }
    
    
    
    
    ///-------------------评论-----------------------------
    func _setComments(__comments:NSArray,__allNum:Int){
        //let _lineH:CGFloat = 20
        //var _h:CGFloat
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
        
        
        let paragraphStyle = NSMutableParagraphStyle()
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
        //let boldFont = UIFont.boldSystemFontOfSize(14)
       
        //var boldAttr = [NSFontAttributeName: boldFont]
        //let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),
         //   NSBackgroundColorAttributeName : UIColor.whiteColor()]
        let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),NSFontAttributeName: UIFont.systemFontOfSize(14)]
        
        var attrString: NSAttributedString = linkString(_commentDict.objectForKey("from_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("from_userId") as! String))
        
        let astr:NSMutableAttributedString = NSMutableAttributedString()
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
        let attrString = NSMutableAttributedString(string: string )
        // the entire string
        let range:NSRange = NSMakeRange(0, attrString.length)
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
        let _action:String = URL.scheme
        print(_action)
        switch _action{
        case "user":
            let _str:String = URL.absoluteString
            let _userId:NSString =  (_str as NSString).substringFromIndex(5)            
            _delegate?._viewUser(_userId as String)
        case "moreComment":
            //println("hahahah")
            _delegate?._moreComment(_indexId)
        case "moreLike":
            _delegate?._moreLike(_indexId)
        default:
            print("")
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
        if __likes.count<1{
            _likeIcon?.hidden = true
            return
        }else{
            _likeIcon?.hidden=false
        }
        
        _likeNumLable?.text = String(__likes.count+23)
        let size:CGSize =  _likeNumLable!.sizeThatFits(CGSize(width: CGFloat.max, height: 17))
        
        _likeNumLable?.frame = CGRect(x:  _defaultSize!.width - Config._gap - size.width, y: 0, width: size.width, height: 17)
        
        
        
        _likeIcon!.frame.origin.x = _likeNumLable!.frame.origin.x - 13 - 5
        
        
        
        
    }
    
    //-----－－－－－－－－－－－按钮侦听
    
    
    func buttonAction(__button:UIButton){
        switch __button{
        case _btn_like:
            _delegate?._buttonAction("like", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_comment:
            _delegate?._buttonAction("comment", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
//        case _btn_share:
//            _delegate?._buttonAction("share", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_collect:
            _delegate?._buttonAction("collect", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
       
        case _btn_moreAction!:
            _delegate?._buttonAction("moreAction", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
            break
        default:
            print("")
        }
    }
    
    
    
    //------------------
    
    
    
    func _setDescription(__str:String){
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 1
        let attributes = [NSParagraphStyleAttributeName : style,NSFontAttributeName:Config._font_social_album_description,NSForegroundColorAttributeName:Config._color_social_gray]
        
        //_description?.font = Config._font_social_album_description
        //_description?.textColor = Config._color_social_gray
        
        
        _description?.attributedText = NSAttributedString(string: __str, attributes:attributes)
        
        
        //_description?.text=__str
    }
    func _setAlbumTitle(__str:String){
        if _albumTitle_label == nil{
            return
        }
        if __str==""{
            _albumTitle_label?.text="未命名图册"
        }else{
            _albumTitle_label?.text=__str
        }
        let _size:CGSize = _albumTitle_label!.sizeThatFits(CGSize(width: _defaultSize!.width-2*_gap, height: CGFloat.max))
        switch _type{
            case "myHome":
                
                
                var _lineNum:CGFloat = 1
                if _size.height>24{
                    _lineNum = 2
                }
                
                
                
                _albumTitle_labelV?.frame = CGRect(x: 0, y: _bottomOfPic-30*_lineNum, width: _defaultSize!.width, height:30*_lineNum)
                _albumTitle_label?.frame = CGRect(x: _gap, y: (_albumTitle_labelV!.frame.height-_size.height)/2, width: _size.width, height: _size.height)
                
            break
        case "status":
            _albumTitle_label?.frame = CGRect(x: _gap, y: 5, width: _size.width, height: _size.height)
            _albumTitle_labelV?.frame = CGRect(x: 0, y: _bottomOfPic, width: _defaultSize!.width, height: _size.height)
            
            break
        default:
            break
        }
        
    }
    func _setUserName(__str:String){
        _userBtn?.setTitle(__str, forState: UIControlState.Normal)
        
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
        if let _url = __pic.objectForKey("thumbnail") as? String{
            _picV!._setPic(NSDictionary(objects:[MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{_ in
                 self._refreshView()
            })
            return
        }else{
            _picV!._setPic(__pic, __block:{_ in
                 self._refreshView()
            })
        }
    }
    
    func _setPics(__pics:NSArray){
        
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




