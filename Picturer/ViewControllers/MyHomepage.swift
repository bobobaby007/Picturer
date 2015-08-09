//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class MyHomepage: UIViewController, UITableViewDataSource, UITableViewDelegate, PicAlbumMessageItem_delegate{
    var _barH:CGFloat = 64
    var _myFrame:CGRect?
    var _userId:String = "000001"
    var _userName:String?
    
    var _signH:CGFloat?
    var _title_label:UILabel?
    var _frameW:CGFloat?
    var _gap:CGFloat?
    var _gapY:CGFloat?
    var _imgW:CGFloat?
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_moreAction:UIButton?
    
    var _tableView:UITableView?
    
    var _dataArray:NSArray=[]
    var _setuped:Bool = false
    
    var _profileDict:NSDictionary?=NSDictionary()
    
    var _profilePanel:UIView?
    var _profile_icon_img:PicView?
    var _btn_edite:UIButton?
    var _btn_share:UIButton?
    var _btn_follow:UIButton?
    var _btn_message:UIButton?
    var _albumNum_label:UILabel?
    var _followed_label:UILabel?//被关注
    var _following_label:UILabel?//关注
    var _sign_text:UITextView?
    var _line_profile:UIView?
    
    
    var _label_followed:UILabel?
     var _label_following:UILabel?
     var _label_album:UILabel?
    
    var _profileH:CGFloat = 171.5
    
    var _scrollView:UIScrollView?
    
    var _heighArray:NSMutableArray?
    var _commentsArray:NSMutableArray?
    var _likeArray:NSMutableArray?
    
    
    
    var _defaultH:CGFloat = 400
    
    var _scrollTopH:CGFloat = 0 //达到这个高度时向上移动
    
    var _inputer:Inputer?
    
    var _viewIned:Bool? = false
    
    var _messageAlertView:UIView?
    var _messageImg:PicView?
    var _messageText:UILabel?
    var _messageIcon:UIImageView?
    var _messageH:CGFloat = 0
    var _messageTap:UITapGestureRecognizer?
    
    var _hasNewMessage:Bool = false
    var _messageArray:NSArray?
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets=false
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    
        setup(self.view.frame)
        _getDatas()
    }
    
    func setup(__frame:CGRect){
        if _setuped {
            return
        }
        _myFrame = __frame
        _frameW = _myFrame!.width
        _gap = 0.04*_frameW!
        _gapY = 0.06*_frameW!
        _imgW = 0.20*_frameW!
        _profileH = _imgW! + 2*_gapY!
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: _myFrame!.width, height: _barH))
        _topBar?.backgroundColor=UIColor(white: 0.1, alpha: 0.98)
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_moreAction=UIButton(frame:CGRect(x: self.view.frame.width-50, y: _barH-44, width: 50, height: 44))
        _btn_moreAction?.setImage(UIImage(named: "edit.png"), forState: UIControlState.Normal)
        _btn_moreAction?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = UIFont.boldSystemFontOfSize(17)
        
        _topBar?.addSubview(_title_label!)
        _topBar?.addSubview(_btn_moreAction!)
        
         //----用户信息面板
        
        _profilePanel = UIView(frame: CGRect(x: 0, y: 0, width: _myFrame!.width, height: _profileH))
        _profilePanel?.backgroundColor = UIColor.whiteColor()
        _line_profile=UIView(frame: CGRect(x: 0, y: _profileH, width: _myFrame!.width, height: 0.5))
        _line_profile?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _profilePanel?.addSubview(_line_profile!)
        
        _profile_icon_img = PicView(frame: CGRect(x: _gap!, y: _gapY!, width: _imgW!, height: _imgW!))
        _profile_icon_img?.scrollEnabled=false
        _profile_icon_img?.minimumZoomScale=1
        _profile_icon_img?.maximumZoomScale=1
        _profile_icon_img?._imgView?.contentMode=UIViewContentMode.ScaleAspectFill
        _profile_icon_img?._imgView?.layer.masksToBounds=true
        _profile_icon_img?._imgView?.layer.cornerRadius = 0.5*_profile_icon_img!.frame.width
        
        _btn_edite = UIButton(frame: CGRect(x: 0.275*_frameW!,y: _gapY!+0.6*_imgW!,width: 2*0.33*(_frameW!-_gap!-0.275*_frameW!),height: 0.4*_imgW!))
        _btn_edite?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_edite?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        _btn_edite?.layer.masksToBounds = true
        _btn_edite?.layer.cornerRadius = 5
        var attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "编辑个人主页")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_edite?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_edite?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_edite?.titleLabel?.font=UIFont.systemFontOfSize(12)
        _btn_edite?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_share = UIButton(frame: CGRect(x: _btn_edite!.frame.origin.x+_btn_edite!.frame.width+3,y: _btn_edite!.frame.origin.y,width: _frameW!-_btn_edite!.frame.origin.x-_btn_edite!.frame.width-3-_gap!,height: _btn_edite!.frame.height))
        _btn_share?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_share?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        _btn_share?.layer.masksToBounds = true
        _btn_share?.layer.cornerRadius = 5
        _btn_share?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "分享")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_share?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_share?.titleLabel?.font=UIFont.systemFontOfSize(12)
        _btn_share?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_follow = UIButton(frame: _btn_edite!.frame)
        _btn_follow?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_follow?.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _btn_follow?.layer.masksToBounds = true
        _btn_follow?.layer.cornerRadius = 5
        _btn_follow?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "＋关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_follow?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_follow?.titleLabel?.font=UIFont.systemFontOfSize(12)
        _btn_follow?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_message = UIButton(frame: _btn_share!.frame)
        _btn_message?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_message?.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _btn_message?.layer.masksToBounds = true
        _btn_message?.layer.cornerRadius = 5
        _btn_message?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "私信")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_message?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_message?.titleLabel?.font=UIFont.systemFontOfSize(12)
        _btn_message?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        
        _label_album = UILabel(frame: CGRect(x: _btn_edite!.frame.origin.x,y: 0.26*_imgW!+_gapY!+3,width: 0.5*_btn_edite!.frame.width,height: 15))
        _label_album?.textColor = UIColor(white: 0.4, alpha: 1)
        _label_album?.textAlignment = NSTextAlignment.Center
        _label_album?.text = "图册"
        _label_album?.font=UIFont.systemFontOfSize(13)
        
        
        _label_followed = UILabel(frame: CGRect(x: _btn_edite!.frame.origin.x+0.5*_btn_edite!.frame.width,y: _label_album!.frame.origin.y,width: 0.5*_btn_edite!.frame.width,height: 15))
        _label_followed?.textColor = UIColor(white: 0.4, alpha: 1)
        _label_followed?.textAlignment = NSTextAlignment.Center
        _label_followed?.text="被关注"
        _label_followed?.font=UIFont.systemFontOfSize(13)
        
        _label_following = UILabel(frame: CGRect(x: _btn_share!.frame.origin.x,y: _label_album!.frame.origin.y,width: _btn_share!.frame.width,height: 15))
        _label_following?.textColor = UIColor(white: 0.4, alpha: 1)
        _label_following?.textAlignment = NSTextAlignment.Center
        _label_following?.text="关注"
        _label_following?.font=UIFont.systemFontOfSize(13)
        
        
        _albumNum_label = UILabel(frame:CGRect(x:_label_album!.frame.origin.x,y:_gapY!+3,width:_label_album!.frame.width,height:20))
        _albumNum_label?.textColor = UIColor.blackColor()
        _albumNum_label?.textAlignment = NSTextAlignment.Center
        _albumNum_label?.font = UIFont.systemFontOfSize(14)
        
        
        
        
        _followed_label = UILabel(frame: CGRect(x: _albumNum_label!.frame.origin.x+_albumNum_label!.frame.width,y: _albumNum_label!.frame.origin.y,width: _albumNum_label!.frame.width,height: _albumNum_label!.frame.height))
        _followed_label?.textColor = UIColor.blackColor()
        _followed_label?.textAlignment = NSTextAlignment.Center
        _followed_label?.font = UIFont.systemFontOfSize(14)
        
        
        
        _following_label = UILabel(frame: CGRect(x: _btn_share!.frame.origin.x,y: _albumNum_label!.frame.origin.y,width: _btn_share!.frame.width,height: _albumNum_label!.frame.height))
        _following_label?.textColor = UIColor.blackColor()
        _following_label?.textAlignment = NSTextAlignment.Center
        _following_label?.font = UIFont.systemFontOfSize(14)
        
        
        
        
        _sign_text = UITextView(frame: CGRect(x: _gap!,y: _imgW!+2*_gap!+3,width: _myFrame!.width-2*_gap!,height: 12))
        _sign_text?.font = UIFont.systemFontOfSize(13)
        _sign_text?.editable=false
        _sign_text?.alpha = 0
        
        
        
        _profilePanel?.addSubview(_profile_icon_img!)
        _profilePanel?.addSubview(_btn_edite!)
        _profilePanel?.addSubview(_btn_share!)
        _profilePanel?.addSubview(_btn_follow!)
        _profilePanel?.addSubview(_btn_message!)
        
        _profilePanel?.addSubview(_followed_label!)
        _profilePanel?.addSubview(_following_label!)
        _profilePanel?.addSubview(_albumNum_label!)
        _profilePanel?.addSubview(_label_album!)
        _profilePanel?.addSubview(_label_followed!)
        _profilePanel?.addSubview(_label_following!)
        
        _profilePanel?.addSubview(_sign_text!)
        //----
        
        
        
        
        
        
        
        
        //---消息提醒----
        
        
        
        _messageAlertView = UIView(frame: CGRect(x: 0, y: _profileH+10, width: 194, height: 40))
        _messageAlertView?.layer.masksToBounds=true
        _messageAlertView?.layer.cornerRadius = 10
        _messageAlertView?.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        
        _messageIcon = UIImageView(frame: CGRect(x: 175, y: 15, width: 6, height: 10))
        _messageIcon?.userInteractionEnabled=false
        _messageIcon?.image = UIImage(named: "message_arrow.png")
        _messageAlertView?.addSubview(_messageIcon!)
        
        _messageText = UILabel(frame: CGRect(x: 60, y: 13, width: 80, height: 12))
        _messageText?.textAlignment = NSTextAlignment.Center
        _messageText?.userInteractionEnabled=false
        _messageText?.font = UIFont.systemFontOfSize(15)
        _messageText?.textColor = UIColor.whiteColor()
        _messageText?.text = "3条新消息"
        _messageAlertView?.addSubview(_messageText!)
        
        _messageTap = UITapGestureRecognizer(target: self, action: Selector("messageTapHander:"))
        _messageAlertView?.addGestureRecognizer(_messageTap!)
        
        
        _messageImg = PicView(frame: CGRect(x: 8, y: 4.5, width: 32, height: 32))
        _messageImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _messageImg?.minimumZoomScale=1
        _messageImg?.userInteractionEnabled=false
        _messageImg?.maximumZoomScale=1
        _messageImg?._imgView?.layer.masksToBounds = true
        _messageImg?._imgView?.layer.cornerRadius = 16
        
        _messageAlertView?.addSubview(_messageImg!)
        
        
        _messageAlertView?.hidden=true
        
        //----
        
        _tableView=UITableView()
        
        _tableView?.backgroundColor=UIColor.clearColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: _barH+_profileH+10, width: _myFrame!.width, height: _myFrame!.height-_barH-_profileH-10)
        _tableView?.registerClass(PicAlbumMessageItem.self, forCellReuseIdentifier: "PicAlbumMessageItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        //_tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        _scrollView = UIScrollView(frame: CGRect(x: 0, y: _barH, width: _myFrame!.width, height: _myFrame!.height-_barH))
        
        
        self.view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        _scrollView!.addSubview(_tableView!)
        //_scrollView?.scrollEnabled=true
        
        _scrollView!.addSubview(_profilePanel!)
        
        _scrollView!.addSubview(_messageAlertView!)
        
        self.view.addSubview(_scrollView!)
        self.view.addSubview(_topBar!)

        
        
        //-----评论输入框
        _inputer = Inputer(frame: _myFrame!)
        _inputer?.setup()
       // _inputer?.hidden=true
        
       
       
        
        

        _topBar?.addSubview(_btn_cancel!)
//
        
//
//        
        _setuped=true
    }
    
    
    
    //提取数据
    func _getMessage(){
        MainAction._getMessages { (array) -> Void in
            self._hasNewMessage = true            
            self._messageArray = array
            
            self._messageImg!._setPic((array.objectAtIndex(0) as! NSDictionary).objectForKey("userImg") as! NSDictionary, __block: { (__dict) -> Void in
                
            })
            self._messageText!.text = String(array.count)+"条新消息"
            self._refreshView()
        }
    }
    //----消息按钮侦听
    
    func messageTapHander(__sender:UITapGestureRecognizer){
        _hasNewMessage = false
        _refreshView()
        _openMessageList()
    }
    
    
    
    func _getDatas(){
        let _dict:NSDictionary = MainAction._getUserProfileAtId(_userId)
        _profileDict = _dict
        
        
        
        MainAction._getAlbumListAtUser(_userId, block: { (array) -> Void in
            
            self._dataArray = array
            self._refreshDatas()
            self._getMessage()
        })
        
       
    }
    
    
    
    //----更新数据
    
    func _refreshDatas(){
        _title_label?.text=_profileDict?.objectForKey("userName") as? String
        _albumNum_label?.text = String(_profileDict?.objectForKey("albumNumber") as! Int)
        _followed_label?.text=String(_profileDict?.objectForKey("followNumber") as! Int)
        _following_label?.text=String(_profileDict?.objectForKey("followingNumber") as! Int)
        _setSign(_profileDict?.objectForKey("sign") as! String)
        _setIconImg(_profileDict?.objectForKey("profileImg") as! NSDictionary)
        
        
        
        //-----初始化数据
        
        _heighArray=NSMutableArray()
        _commentsArray=NSMutableArray()
        _likeArray = NSMutableArray()
        for var i:Int=0; i<_dataArray.count;++i{
            _heighArray?.addObject(_defaultH)
            MainAction._getCommentsOfAlubm(String(i), block: { (array) -> Void in
                self._commentsArray?.addObject(array)
            })
            MainAction._getLikesOfAlubm(String(i), block: { (array) -> Void in
                self._likeArray?.addObject(array)
            })
        }
        _tableView?.reloadData()
        
    }
    func _setSign(__str:String){
        _sign_text?.text=__str
        
        let _size:CGSize = _sign_text!.sizeThatFits(CGSize(width: _sign_text!.frame.width, height: CGFloat.max))
        
        _sign_text?.frame = CGRect(x: _gap!,y: _sign_text!.frame.origin.y,width: _myFrame!.width-2*_gap!,height:_size.height)
        
        //_sign_text?.frame = CGRect(x: _gap!,y: _imgW!+2*_gap!,width: _myFrame!.width-2*_gap!,height: _sign_text!.contentSize.height)
    }
    func _setIconImg(__pic:NSDictionary){
        _profile_icon_img?._setPic(__pic,__block: { (__dict) -> Void in
            
           // self._refreshView()
        })
    }
    
    func _getListHander(__list:NSArray){
        
    }
    //----------------刷新布局
    func _refreshView(){
        
        if _userId == MainAction._userId{
            _btn_share?.hidden=false
            _btn_edite?.hidden=false
            _btn_follow?.hidden=true
            _btn_message?.hidden=true
            _btn_moreAction?.hidden=false
            
        }else{
            _btn_share?.hidden=true
            _btn_edite?.hidden=true
            _btn_follow?.hidden=false
            _btn_message?.hidden=false
            _btn_moreAction?.hidden=true
            
            _hasNewMessage = false
        }
        
        
       // _sign_text?.text=
        
        if _sign_text!.text == ""{
            _signH = 0
        }else{
            _signH = _sign_text!.frame.height
        }
        
        
        
        UIView.beginAnimations("go", context: nil)
        _sign_text?.frame = CGRect(x: _gap!,y: _sign_text!.frame.origin.y,width: _myFrame!.width-2*_gap!,height: _signH!)
        _sign_text?.alpha=1
        
        _profileH = _sign_text!.frame.origin.y + _sign_text!.frame.height + _gap!
       
        
        
        _profilePanel?.frame = CGRect(x: 0, y: 0, width: _myFrame!.width, height: _profileH)
        _line_profile?.frame = CGRect(x: 0, y: _profileH, width: _myFrame!.width, height: 0.5)
        
        if _hasNewMessage{
            _messageAlertView!.frame = CGRect(x: _myFrame!.width/2 - 194/2, y: _profileH+10, width: 194, height: 40)
           
            _messageAlertView?.hidden=false
            _messageH = 40
        }else{
            _messageAlertView?.hidden=true
            _messageH = 0
        }
        _tableView?.frame = CGRect(x: 0, y: _profileH+20+_messageH, width:  _myFrame!.width, height: _tableView!.contentSize.height)
        _tableView?.scrollEnabled = false
        _scrollView?.contentSize = CGSize(width: _myFrame!.width, height: _tableView!.frame.origin.y+_tableView!.frame.height)
        UIView.commitAnimations()
    }
    
    //----table 代理
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /*
       // println(scrollView.contentOffset.y)
        var _offsetY:CGFloat = 0
        var _frameOff:CGFloat = 10
        var _tableToY:CGFloat = _tableView!.frame.origin.y
        
        
       
        
        
        
        if scrollView.contentOffset.y > _scrollTopH{
            _offsetY = scrollView.contentOffset.y-_scrollTopH
            UIApplication.sharedApplication().statusBarHidden=true
            
        }else{
            UIApplication.sharedApplication().statusBarHidden=false
        }
        if _offsetY>_profileH+_barH+_frameOff{
           _offsetY = _profileH+_barH+_frameOff
        }else{
            
        }
        
        if scrollView.contentOffset.y>0{
            _tableView?.frame = CGRect(x: 0, y: _barH+_profileH+_messageH-_offsetY+_frameOff, width: _myFrame!.width, height: _myFrame!.height-_barH-_profileH-_messageH+_offsetY-_frameOff)
        }else{
            
        }
        
        _messageAlertView?.frame = CGRect(x: _messageAlertView!.frame.origin.x, y:_barH+_profileH+_gap!-_offsetY, width: _messageAlertView!.frame.width, height: _messageAlertView!.frame.height)
        //_topBar?.frame=CGRect(x: 0, y:0-_offsetY, width: _myFrame!.width, height: _barH)

*/
        
    }
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
       // println(scrollView.contentOffset)
        
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //var cell:PicAlbumMessageItem? = tableView.viewWithTag(100+indexPath.row) as? PicAlbumMessageItem
        //var cell:PicAlbumMessageItem = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as! PicAlbumMessageItem
       // println(_heighArray?.count)
        if _heighArray!.count>=indexPath.row+1{
            return CGFloat(_heighArray!.objectAtIndex(indexPath.row) as! NSNumber)
        }
        //println(_heighArray.objectAtIndex(indexPath.row))
        return 700
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:PicAlbumMessageItem?
        //cell = tableView.viewWithTag(100+indexPath.row) as? PicAlbumMessageItem
        cell = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as? PicAlbumMessageItem
        
        
        cell!.setup(CGSize(width: self.view.frame.width, height: _defaultH))
        cell!._openPanel(false)
        
        cell!.separatorInset = UIEdgeInsetsZero
        cell!.preservesSuperviewLayoutMargins = false
        cell!.layoutMargins = UIEdgeInsetsZero
        //cell!.tag = 100+indexPath.row
        let _array:NSArray = _commentsArray?.objectAtIndex(indexPath.row) as! NSArray
        cell!._setComments(_array, __allNum: _array.count)
        
        let _likeA:NSArray = _likeArray?.objectAtIndex(indexPath.row) as! NSArray
        cell!._setLikes(_likeA,__allNum: _likeA.count)
        cell!._userId = _userId
        cell!._indexId = indexPath.row
        cell!._delegate=self
        
        
        
    
        cell!._setPic((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("cover") as! NSDictionary)
        cell!._setUserImge(_profileDict?.objectForKey("profileImg") as! NSDictionary)
        cell!._setAlbumTitle((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("title") as! String)
        
        cell!._setDescription((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("description") as! String)
        cell!._setUpdateTime("下午 2:00 更新")
        cell!._setUserName(_profileDict!.objectForKey("userName") as! String)
        //cell!._refreshView()
        return cell!
    }
    //------相册单元代理
    func _resized(__indexId: Int, __height: CGFloat) {
        //println("changeH")
        
        var _lastH:CGFloat? = -10
        if _heighArray!.count>=__indexId+1{
         _lastH = CGFloat(_heighArray!.objectAtIndex(__indexId) as! NSNumber)
        }
        _heighArray![__indexId] = __height
        if _lastH != __height{
            _tableView?.reloadData()
            _refreshView()
        }
        
       // println(_heighArray)
    }
    func _viewAlbum(__albumIdex:Int) {
        
        
        if _userId == MainAction._userId{
            MainAction._getPicsListAt(__albumIdex, block: { (array) -> Void in
                var _controller:Social_pic = Social_pic()
                _controller._showIndexAtPics(0, __array: array)
                self.navigationController?.pushViewController(_controller, animated: true)

            })
            return
        }
        
        
        MainAction._getPicsListAtAlbumId("00003", block: { (array) -> Void in
            var _controller:Social_pic = Social_pic()
            _controller._showIndexAtPics(0, __array: array)
             self.navigationController?.pushViewController(_controller, animated: true)
            
        })
        
       
        
    }
    func _moreComment(__indexId: Int) {
        var _controller:CommentList = CommentList()
        //println(__dict)
        _controller._dataArray = NSMutableArray(array: (_commentsArray!.objectAtIndex(__indexId) as? NSArray)!)
        self.navigationController?.pushViewController(_controller, animated: true)
    }
    func _moreLike(__indexId: Int) {
        println(__indexId)
    }
    func _viewUser(__userId: String) {
        //println(__userId)
        let _contr:MyHomepage=MyHomepage()
        _contr._userId = __userId
        self.navigationController?.pushViewController(_contr, animated: true)        
    }
    func _buttonAction(__action: String, __dict: NSDictionary) {
        switch __action{
            case  "like":
                if _hasUserInLikesAtIndex(__dict.objectForKey("indexId") as! Int, __userId: MainAction._currentUser.objectForKey("userId") as! String){
                    return
                }
                var _arr:NSMutableArray = NSMutableArray(array: self._likeArray!)
                var _dict:NSMutableArray = NSMutableArray(array:_arr.objectAtIndex(__dict.objectForKey("indexId") as! Int) as! NSArray)
                let _user:NSDictionary = MainAction._currentUser as NSDictionary
                _dict.addObject(NSDictionary(objects: [_user.objectForKey("userName") as! String,_user.objectForKey("userId") as! String], forKeys: ["userName","userId"]))
                _arr[__dict.objectForKey("indexId") as! Int] = _dict
                self._likeArray = _arr
                MainAction._postLike(NSDictionary())
                
                _tableView?.reloadData() //--------使用在线接口时全部请求信息后侦听里面再重新加载
            
            break
            case "comment":
                var _cell:PicAlbumMessageItem = _tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: __dict.objectForKey("indexId") as! Int, inSection: 0)) as! PicAlbumMessageItem
                //println(_cell.frame.origin.y)
                //UIView.beginAnimations("offset", context: nil)
                /*-----在当前页打开输入框
                var _offY:CGFloat=_cell.frame.origin.y+_cell.frame.height-(self.view.frame.height-258)
                if _offY<0.8*(_barH+_profileH+10){
                    _offY = 0.8*(_barH+_profileH+10)
                }
                
                _tableView?.setContentOffset(CGPoint(x: 0, y: _offY), animated: true)
                
                UIView.commitAnimations()
                _inputer =  Inputer(frame: self.view.frame)
                _inputer?.setup()
                
                self.view.addSubview(_inputer!)
                _inputer?._delegate = self
                _inputer?._open()
                */
              
                var _controller:CommentList = CommentList()
                //println(__dict)
                _controller._dataArray = NSMutableArray(array: (_commentsArray!.objectAtIndex(_cell._indexId) as? NSArray)!)
                
                self.navigationController?.pushViewController(_controller, animated: true)
                
            break
        default:
            break
        }
        
    }
    
    func _hasUserInLikesAtIndex(__indexId:Int,__userId:String)->Bool{
        let _arr:NSArray = self._likeArray?.objectAtIndex(__indexId) as! NSArray
        let _n:Int = _arr.count
        
        for var i:Int = 0 ; i<_n ;++i{
            if (_arr[i] as! NSDictionary).objectForKey("userId") as! String == __userId {
                return true
            }
        }
        
        
        return false
    }
    
    
    
    //-----输入框代理
    
    func _inputer_send(__dict:NSDictionary) {
        println(__dict.objectForKey("text"))
        _inputer?._close()
    }
    func _inputer_changed(__dict: NSDictionary) {
        println(__dict.objectForKey("text"))
    }
    //-------------
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_edite!:
            println("")
        default:
            println("")
        }
    }
    
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        //setup(<#__frame: CGRect#>)
        
        
        //_setSign(_profileDict!.objectForKey("sign") as! String)
        //_setIconImg(_profileDict!.objectForKey("profileImg") as! NSDictionary)
    }
    override func viewDidAppear(animated: Bool) {
        if _viewIned!{
            
        }else{
            _refreshView()
            _viewIned=true
        }
        
    }
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
            return
        case _btn_moreAction!:
            var _alertController:UIAlertController = UIAlertController()
            
            var _action:UIAlertAction = UIAlertAction(title: "消息列表", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self._hasNewMessage = false
                self._refreshView()
                self._openMessageList()
            })
            
            var _actionCancel:UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            _alertController.addAction(_action)
            _alertController.addAction(_actionCancel)
            
//            var _v:UIView = _alertController.view.subviews.first as! UIView
//            var _v1:UIView = _v.subviews.first as! UIView
//            _v1.backgroundColor = UIColor.redColor()
            
            self.navigationController?.presentViewController(_alertController, animated: true, completion: nil)
            return
        default:
            return
        }
    }
    
    //---打开消息列表
    func _openMessageList(){
        
        var _controller:MessageList = MessageList()
        self.navigationController?.pushViewController(_controller, animated: true)
    }
    
    
}

