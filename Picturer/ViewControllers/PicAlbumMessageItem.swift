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
    func _moreComment(__indexId:Int)//----查看更多评论
    func _viewUser(__userId:String)
    func _viewAlbum(__albumIndex:Int)
    func _viewAlbumDetail(__albumIndex:Int) //---查看相册详情
    func _viewPicsAtIndex(__array:NSArray,__index:Int)
    func _buttonAction(__action:String,__dict:NSDictionary)
    
}

class PicAlbumMessageItem:  UITableViewCell,UITextViewDelegate{
    var _picsW:CGFloat = 0
    let _gapForPic:CGFloat = 2
    
    var _showAllComments:Bool = false //是否显示全部评论
    
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
    var _btn_moreLike:UIButton?
    
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
    
    var _statusText:UITextView?//----显示为状态时文字
    
    var _liked:Bool = false //----点过赞
    var _collected:Bool = false //---收藏过
    
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
        
        
        _btn_moreLike = UIButton(frame: CGRect(x: _defaultSize!.width - 13 - Config._gap, y: -10, width: 50, height: 30))
        _btn_moreLike?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _toolsOpenButton = UIButton(frame: CGRect(x: _defaultSize!.width-27.5-_gap, y: _gap, width: 27.5, height: 15))
        _toolsOpenButton?.setImage(UIImage(named: "toolsBtn.png"), forState: UIControlState.Normal)
        _toolsOpenButton?.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        //----工具条
        _toolsGap = (_defaultSize!.width-80)/4
        _toolsButtonPanel = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        
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
        _toolsPanel = UIView()
        _toolsPanel?.backgroundColor = UIColor.clearColor()
        _toolsPanel?.addSubview(_likeIcon!)
        _toolsPanel?.addSubview(_likeNumLable!)
        _toolsPanel?.addSubview(_btn_moreLike!)
        _toolsPanel?.addSubview(_toolsButtonPanel!)
        
        
        
        
        _commentsPanel = UIView(frame: CGRect(x: 0, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height, width: _defaultSize!.width, height: 36))
        _commentsPanel?.backgroundColor = UIColor.clearColor()
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("_tapHander:"))
        
        _commentsPanel?.addGestureRecognizer(_tapC!)
        
        
        
        _toolsPanel?.hidden = true
        _commentsPanel?.hidden = true
        
        
        _attributeStr = NSMutableAttributedString()
        
        _commentText = UITextView(frame: CGRect(x: 0, y: 0, width: _defaultSize!.width-_gap*2, height: 20))
        _commentText?.textContainerInset =  UIEdgeInsetsMake(-3, 0, 0, 0)  //{{-10,-5},{0,0}} // UIEdgeInsetsZero
        _commentText?.textContainer.lineFragmentPadding = 0
        _commentText?.font = Config._font_social_album_description  //UIFont.systemFontOfSize(14)
        _commentText!.attributedText = _attributeStr!
        _commentText?.backgroundColor =  UIColor.clearColor()
        
        _commentText!.delegate=self
        
        _commentText!.selectable=true
        _commentText!.editable=false
        _commentText?.userInteractionEnabled=true
        
        _moreCommentText = UITextView()
        _moreCommentText?.textContainerInset = UIEdgeInsetsMake(-3, 0, 0, 0)
        _moreCommentText?.scrollEnabled = false
        _moreCommentText?.textContainer.lineFragmentPadding = 0
        _moreCommentText?.backgroundColor = UIColor.clearColor()
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
        
        self.addSubview(_description!)
        self.addSubview(_toolsPanel!)
        self.addSubview(_commentsPanel!)
        
        
        _albumTitle_labelV?.addSubview(_albumTitle_label!)
        
        
        
        _setuped=true
        
        
    }
    //----设定工具条
    func setupToolsBar(){
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
    }
    //---设定图片
    func setupPic(){
        _picV = PicView(frame: CGRect(x: 0, y: 45, width: _defaultSize!.width, height: _defaultSize!.width))
        _picV?._setImage("loadingPicBg.png")
        _picV?.scrollEnabled=false
        _picV?.maximumZoomScale = 1
        _picV?.minimumZoomScale = 1
        _picV?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _picV?.layer.masksToBounds = true
        
        let _tapPic:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("_buttonTapHander:"))
        _picV?.addGestureRecognizer(_tapPic)
        
        _bottomOfPic = _picV!.frame.origin.y + _picV!.frame.height
        
        self.addSubview(_picV!)
    }
    //---设定标题
    func setupTitle(){
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
        //_albumTitle_label?.userInteractionEnabled=false
        _albumTitle_label?.textColor = UIColor.whiteColor()
        _albumTitle_label?.font = Config._font_social_album_title
        _albumTitle_label?.textColor = UIColor.whiteColor()
        self.addSubview(_albumTitle_labelV!)
    }
    //----作为主页时设定
    func _setUpForMyHome(){
        setupToolsBar()
        setupPic()
        setupTitle()
        
    }
    func _setUpForStatus(){
        setupToolsBar()
        setupPic()
        //setupTitle()
        _btn_collect.hidden = true
        
        
        _statusText = UITextView(frame: CGRect(x: Config._gap, y: _bottomOfPic+Config._gap, width: _defaultSize!.width-2*_gap, height: 20))
        _statusText?.font = Config._font_social_album_description
        _statusText?.backgroundColor = UIColor.clearColor()
        _statusText?.textContainerInset = UIEdgeInsetsMake(-3, 0, 0, 0)
        _statusText?.textContainer.lineFragmentPadding = 0
        _statusText?.textContainer.maximumNumberOfLines = 1
        _statusText?.textContainer.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        _statusText?.editable=false
        _statusText?.scrollEnabled = false
        _statusText?.textAlignment = NSTextAlignment.Left
        _statusText?.delegate = self
        
        
        addSubview(_statusText!)
       // _setStatusString(3, __albumName: "时光的舒服的沙发电视柜第三个第三个第四个大帅哥的是非得失个大", __albumId: "3465rtdhfhdfg")
    }
    
    func _tapHander(__sender:UIGestureRecognizer){
        print(__sender.view)
        _delegate?._moreComment(_indexId)
    }
    
    //-------------------------调整布局-----------------
    
    func _refreshView(){
        
        var _desH:CGFloat = 0
        
        
        if _type == "status"{
            //---
        }else{
            if _description!.text == ""{
                
            }else{
                let size:CGSize = _description!.sizeThatFits(CGSize(width: _defaultSize!.width-_gap*2, height: CGFloat.max))
                _desH = size.height+_gap-3
            }
        }
        switch _type{
            case "myHome":
                _description?.frame = CGRect(x: _gap, y: _bottomOfPic+_gap, width: _defaultSize!.width-_gap*2, height: _desH)
                _toolsPanel?.frame = CGRect(x: 0, y: _bottomOfPic+_gap+_desH, width: _defaultSize!.width, height: 20)
            break
            case "status":
                _toolsPanel?.frame = CGRect(x: 0, y: _bottomOfPic+43, width: _defaultSize!.width, height: 20)
            break
        default:
            break
        }
        
        
        _toolsPanel?.hidden = false
        _commentsPanel?.hidden = false
        
//        let _commH:CGFloat = _commentText!.contentSize.height
        let _size = _commentText!.sizeThatFits(CGSize(width: _defaultSize!.width-_gap*2, height: CGFloat.max))
        let _commH:CGFloat = _size.height
        _commentText?.frame = CGRect(x: 0, y: 0, width: _defaultSize!.width-_gap*2, height: _commH)
        
        var _moreComentH:CGFloat = 0
        
        if _moreCommentText?.text == ""{
        
        }else{
            let _size_2 = _moreCommentText!.sizeThatFits(CGSize(width: _defaultSize!.width-_gap*2, height: CGFloat.max))
            _moreComentH = _size_2.height-3
        }
        
        let _moreCommentGap:CGFloat = 5
        
        _moreCommentText?.frame = CGRect(x: 0, y: _commH+_moreCommentGap , width: _defaultSize!.width-2*Config._gap, height: _moreComentH)
        
        var _bgH:CGFloat = 0
        
        _bgH = _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height+_gap
        
        _commentsPanel?.clipsToBounds = false
        _commentText?.clipsToBounds = false
        
        if _commentText?.text==""{
        _commentsPanel?.frame = CGRect(x: _gap, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height+Config._gap, width: _defaultSize!.width-2*_gap, height: 0)
        }else{
            if _moreComentH == 0{//----如果没有更多评论
                _commentsPanel!.frame = CGRect(x: _gap, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height+Config._gap, width: _defaultSize!.width-2*_gap, height: _commH)
                _bgH = _commentsPanel!.frame.origin.y+_commentsPanel!.frame.height+_gap-3
            }else{//----有更多评论
                _commentsPanel!.frame = CGRect(x: _gap, y: _toolsPanel!.frame.origin.y+_toolsPanel!.frame.height+Config._gap, width: _defaultSize!.width-2*_gap, height: _commH+_moreCommentGap+_moreComentH)
               _bgH = _commentsPanel!.frame.origin.y+_commentsPanel!.frame.height+_gap
            }
            
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
        print("评论：",__comments)
                
        let _n:Int = __comments.count
        
        
        _attributeStr = NSMutableAttributedString(string: "")
        
        for var i:Int = 0 ; i<_n; ++i{
            
            if i>2  && !_showAllComments{
                break
            }
            
            
            if i>0 {
                _attributeStr?.appendAttributedString(NSAttributedString(string: "\n"))
            }
            let _commentDict:NSDictionary = __comments.objectAtIndex(__comments.count - 1 - i) as! NSDictionary
            
            
            _attributeStr?.appendAttributedString(commentString(_commentDict))
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        _attributeStr?.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, _attributeStr!.length))
        
        _commentText!.attributedText = _attributeStr!
        
        _commentText?.linkTextAttributes = [NSForegroundColorAttributeName:Config._color_social_blue]
       
        if _n>3 && !_showAllComments{
            _moreCommentText?.attributedText = linkString("全部"+String(__allNum)+"条评论",withURLString:"moreComment:")
            _moreCommentText?.linkTextAttributes = [NSForegroundColorAttributeName:Config._color_gray_time]
        }else{
            _moreCommentText?.text = ""
        }
        
        _refreshView()
    }
    
    
    //---处理一遍网上数据
    func _dealWidthComment(__commentDict:NSDictionary)->NSDictionary{
        let _com:NSDictionary = __commentDict
        
        //print("评论:",_com)
        
        let _by:NSDictionary = _com.objectForKey("by") as! NSDictionary
        
        
        let from_userName:String = _by.objectForKey("nickname") as! String
        let from_userId:String = _by.objectForKey("_id") as! String
        let userImg:NSDictionary = MainInterface._userAvatar(_by)
        
        var to_userName:String = ""
        
        var to_userId:String = ""
        
        if let _re:NSDictionary = _com.objectForKey("re") as? NSDictionary{
            to_userName = _re.objectForKey("nickname") as! String
            to_userId = _re.objectForKey("_id") as! String
        }
        let comment:String = _com.objectForKey("text") as! String
        let _d:NSDictionary = NSDictionary(objects: [from_userName,to_userName,from_userId,to_userId,comment,userImg], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","userImg"])
        return _d
    }
    
    //-----评论文字设置
    
    
    
    func commentString(__commentDict:NSDictionary) -> NSAttributedString {
        //let boldFont = UIFont.boldSystemFontOfSize(14)
        //var _commentDict = __commentDict
        let _commentDict = _dealWidthComment(__commentDict)
        //var boldAttr = [NSFontAttributeName: boldFont]
        //let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),
         //   NSBackgroundColorAttributeName : UIColor.whiteColor()]
        let normalAttr = [NSForegroundColorAttributeName : Config._color_social_gray,NSFontAttributeName: Config._font_social_album_description]
        
        var attrString: NSAttributedString = linkString(_commentDict.objectForKey("from_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("from_userId") as! String))
        
        let astr:NSMutableAttributedString = NSMutableAttributedString()
        astr.appendAttributedString(attrString)
        
        if _commentDict.objectForKey("to_userName") == nil || _commentDict.objectForKey("to_userName") as! String == "" {
            
        }else{
            attrString = NSAttributedString(string: " 回复 ", attributes:normalAttr)
            astr.appendAttributedString(attrString)
            astr.appendAttributedString(linkString(_commentDict.objectForKey("to_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("to_userId") as! String)))
        }
        attrString = NSAttributedString(string: "：", attributes:normalAttr)
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
        
        attrString.addAttribute(NSFontAttributeName, value:Config._font_social_album_description, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:Config._color_social_blue, range:range)
        attrString.addAttribute(NSLinkAttributeName, value:withURLString, range:range)
        
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        attrString.endEditing()
        return attrString
    }
    
    //-----文字链接代理
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        _delegate?._moreComment(_indexId)
//        return false
//    }
    
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
            break
            //_delegate?._moreLike(_indexId)
        case "album":
            //_delegate?._moreLike(_indexId)
            break
        case "albumDetail":
            _delegate?._viewAlbumDetail(_indexId)
            break
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
        if self.superview != nil && _tapC != nil{
            self.superview?.removeGestureRecognizer(_tapC!)
        }
        
    }
    //-------点赞人----取消
    func _setLikes(__likes:NSArray,__allNum:Int){
        if __likes.count<1{
            _likeIcon?.hidden = true
            _btn_moreLike?.hidden = true
            return
        }else{
            _likeIcon?.hidden=false
            _btn_moreLike?.hidden = false
        }
        _likeNumLable?.text = String(__likes.count)
        let size:CGSize =  _likeNumLable!.sizeThatFits(CGSize(width: CGFloat.max, height: 17))
        _likeNumLable?.frame = CGRect(x:  _defaultSize!.width - Config._gap - size.width, y: 0, width: size.width, height: 17)
        _likeIcon!.frame.origin.x = _likeNumLable!.frame.origin.x - 13 - 5
        _btn_moreLike?.frame = CGRect(x: _likeIcon!.frame.origin.x, y: _likeIcon!.frame.origin.y-5, width: _likeIcon!.frame.width+5+size.width, height: 17+10)
    }
    
    //----点赞数量
    func _setLikeNum(__num:Int){
        if __num<1{
            _likeIcon?.hidden = true
            _btn_moreLike?.hidden = true
            return
        }else{
            _likeIcon?.hidden=false
            _btn_moreLike?.hidden = false
        }
        _likeNumLable?.text = String(__num)
        let size:CGSize =  _likeNumLable!.sizeThatFits(CGSize(width: CGFloat.max, height: 17))
        _likeNumLable?.frame = CGRect(x:  _defaultSize!.width - Config._gap - size.width, y: 0, width: size.width, height: 17)
        _likeIcon!.frame.origin.x = _likeNumLable!.frame.origin.x - 13 - 5
        _btn_moreLike?.frame = CGRect(x: _likeIcon!.frame.origin.x, y: _likeIcon!.frame.origin.y-5, width: _likeIcon!.frame.width+5+size.width, height: 17+10)
    }
    
    //---是否点过赞
    func _setLiked(__set:Bool){
        _liked = __set
        if _liked{
            _btn_like.setImage(UIImage(named: "like_on"), forState: UIControlState.Normal)
        }else{
            _btn_like.setImage(UIImage(named: "like_off"), forState: UIControlState.Normal)
        }
    }
    
    //---是否收藏过
    func _setCollected(__set:Bool){
        _collected = __set
        if _collected{
            _btn_collect.setImage(UIImage(named: "collect_on"), forState: UIControlState.Normal)
        }else{
            _btn_collect.setImage(UIImage(named: "collect_off"), forState: UIControlState.Normal)
        }
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
        case _btn_moreLike!:
            print("sssss")
            _delegate?._buttonAction("moreLike", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
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
    //-----
    
    //----设定相册标题--目前只有主页有这个设定
    
    func _setAlbumTitle(__str:String,__num:Int){
        if _albumTitle_label == nil{
            return
        }
        var _str:String
        if __str==""{
            _str="未命名图册"
        }else{
            _str=__str
            
        }
        
        let attrString = NSMutableAttributedString(string: _str )
        // the entire string
        let range:NSRange = NSMakeRange(0, attrString.length)
        attrString.beginEditing()
        
        attrString.addAttribute(NSFontAttributeName, value:Config._font_cell_title, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        attrString.endEditing()
        
        let _numString = NSMutableAttributedString(string: "   "+String(__num)+"张")
        let _numRange = NSMakeRange(0,_numString.length)
        _numString.addAttribute(NSFontAttributeName, value: Config._font_social_album_description, range: _numRange)
        _numString.addAttribute(NSForegroundColorAttributeName, value: Config._color_gray_description, range: _numRange)
        
        attrString.appendAttributedString(_numString)
        
        _albumTitle_label?.attributedText = attrString
        
        
        let _size:CGSize = _albumTitle_label!.sizeThatFits(CGSize(width: _defaultSize!.width-2*_gap, height: CGFloat.max))
        var _lineNum:CGFloat = 1
        if _size.height>24{
            _lineNum = 2
        }
        _albumTitle_labelV?.frame = CGRect(x: 0, y: _bottomOfPic-30*_lineNum, width: _defaultSize!.width, height:30*_lineNum)
        _albumTitle_label?.frame = CGRect(x: _gap, y: (_albumTitle_labelV!.frame.height-_size.height)/2, width: _size.width, height: _size.height)
    }
    //-----设定状态标题，包含更新图片数量，相册名称,用于朋友，妙人
    func _setStatusString(__picNum:Int,__albumName:String,__albumId:String){
        //_statusText?.text = +__albumName
    
        let normalAttr = [NSForegroundColorAttributeName : Config._color_gray_time,NSFontAttributeName: Config._font_social_album_description]
        
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string: "更新了\(String(__picNum))张图片至 ", attributes:normalAttr)
        
        attrString.appendAttributedString(linkString(__albumName, withURLString: "albumDetail:"+__albumId))
        
        _statusText?.attributedText = attrString
        
        _statusText?.linkTextAttributes = [NSForegroundColorAttributeName:Config._color_social_blue]
    }
    
    
    func _setUserName(__str:String){
        _userBtn?.setTitle(__str, forState: UIControlState.Normal)
    }
    func _setUpdateTime(__str:String){
        _updateTime_label?.text=__str
    }
    func _setUserImge(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: {[weak self](__dict) -> Void in
//            if let strongSelf = self {
//                //print("strongSelf",strongSelf)
//                strongSelf._refreshView()
//            }
        })
    }
    
    func _setPic(__pic:NSDictionary){
        //println(__pic)
       //  _pic?.image = UIImage(named: __pic.objectForKey("url") as! String)
        if let _url = __pic.objectForKey("thumbnail") as? String{
            _picV!._setPic(NSDictionary(objects:[MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{[weak self] _ in
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self?._refreshView()
//                })
            })
            return
        }else{
            _picV!._setPic(__pic, __block:{[weak self] _ in
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self?._refreshView()
//                })
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




