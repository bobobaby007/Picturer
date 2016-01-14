//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class MyHomepage: UIViewController, UITableViewDataSource, UITableViewDelegate, PicAlbumMessageItem_delegate,MyAlerter_delegate{
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
    
    var _tableView:UITableView?
    
    var _dataArray:NSArray=[]
    var _setuped:Bool = false
    
    var _profileDict:NSDictionary?
    
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
    
    
    var _label_sex_n_city:UILabel?
    
    
    var _btn_followed:UIButton?
    var _btn_following:UIButton?
    var _btn_album:UIButton?
    
    var _profileH:CGFloat = 152//-----面板高度
    var _buttonH:CGFloat = 30 //---按钮高度
    var _buttonW:CGFloat = 125//---按钮宽度
    var _buttonGap:CGFloat = 1 //---按钮间距
    
    var _scrollView:UIScrollView?
    
    
    var _allDatasArray:NSMutableArray? //------其他信息，以相册id为锚点
    var _coverArray:NSMutableArray?
    var _imagesArray:NSMutableArray?//-----每个相册里的图片
    var _heighArray:NSMutableArray?
    var _commentsArray:NSMutableArray?
    var _likeArray:NSMutableArray?
    var _defaultH:CGFloat = 632
    
    var _scrollTopH:CGFloat = 0 //达到这个高度时向上移动
    
    var _inputer:Inputer?
    
    var _viewIned:Bool? = false
    
    var _messageTap:UITapGestureRecognizer?
    var _messageImg:PicView?
    
    var _hasNewMessage:Bool = false
    var _messageArray:NSArray?
    var _naviDelegate:Navi_Delegate?
    
    
    var _alerter:MyAlerter?
    var _currentEditeIndex:Int?
    
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
        //_profileH = _imgW! + 2*_gapY!
        _buttonW = (_myFrame!.width-2*_buttonGap)/3
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: _myFrame!.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = Config._font_topbarTitle
        
        _topBar?.addSubview(_title_label!)
        
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
        
        _btn_edite = UIButton(frame: CGRect(x: 0.275*_frameW!,y: _gapY!+(_imgW!-30)/2,width: 2*0.33*(_frameW!-_gap!-0.275*_frameW!),height: 30))
        _btn_edite?.setTitleColor(Config._color_social_gray, forState: UIControlState.Normal)
        _btn_edite?.backgroundColor = UIColor(white: 1, alpha: 1)
        _btn_edite?.layer.borderWidth = 1
        _btn_edite?.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        _btn_edite?.layer.masksToBounds = true
        _btn_edite?.layer.cornerRadius = 5
        var attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "编辑个人主页")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_edite?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_edite?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_edite?.titleLabel?.font=Config._font_social_button
        _btn_edite?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_share = UIButton(frame: CGRect(x: _btn_edite!.frame.origin.x+_btn_edite!.frame.width+3,y: _btn_edite!.frame.origin.y,width: _frameW!-_btn_edite!.frame.origin.x-_btn_edite!.frame.width-3-_gap!,height: _btn_edite!.frame.height))
        _btn_share?.setTitleColor(Config._color_social_gray, forState: UIControlState.Normal)
        _btn_share?.backgroundColor = UIColor(white: 1, alpha: 1)
        _btn_share?.layer.borderWidth = 1
        _btn_share?.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        _btn_share?.layer.masksToBounds = true
        _btn_share?.layer.cornerRadius = 5
        _btn_share?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "分享")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_share?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_share?.titleLabel?.font=Config._font_social_button
        _btn_share?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_follow = UIButton(frame: _btn_edite!.frame)
        _btn_follow?.setTitleColor(Config._color_social_gray, forState: UIControlState.Normal)
        _btn_follow?.backgroundColor = Config._color_yellow
        _btn_follow?.layer.masksToBounds = true
        _btn_follow?.layer.cornerRadius = 5
        _btn_follow?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "＋关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_follow?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_follow?.titleLabel?.font=Config._font_social_button
        _btn_follow?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_message = UIButton(frame: _btn_share!.frame)
        _btn_message?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_message?.backgroundColor = Config._color_yellow
        _btn_message?.layer.masksToBounds = true
        _btn_message?.layer.cornerRadius = 5
        _btn_message?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "私信")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_message?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_message?.titleLabel?.font=Config._font_social_button
        _btn_message?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)

        
        _btn_album = UIButton(frame: CGRect(x: 0,y: _profileH - _buttonH,width: _buttonW,height: _buttonH))
        _btn_album?.backgroundColor = Config._color_black_title
        _btn_album?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "图册")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_album?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_followed?.setTitleColor(Config._color_white_title, forState: UIControlState.Normal)
        _btn_album?.titleLabel?.font=Config._font_social_button_2
        //_btn_album?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_followed = UIButton(frame: CGRect(x: _btn_album!.frame.origin.x + _buttonW + _buttonGap,y: _btn_album!.frame.origin.y,width: _buttonW,height: _buttonH))
        _btn_followed?.backgroundColor = Config._color_black_title
        _btn_followed?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "被关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_white_title, range: NSMakeRange(0, attributedString.length) )
        _btn_followed?.setTitleColor(Config._color_white_title, forState: UIControlState.Normal)
        _btn_followed?.titleLabel?.font=Config._font_social_button_2
        _btn_followed?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_following = UIButton(frame: CGRect(x: _btn_album!.frame.origin.x + 2*_buttonW + 2*_buttonGap,y: _btn_album!.frame.origin.y,width: _buttonW,height: _buttonH))
        _btn_following?.backgroundColor = Config._color_black_title
        _btn_following?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_following?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_followed?.setTitleColor(Config._color_white_title, forState: UIControlState.Normal)
        _btn_following?.titleLabel?.font=Config._font_social_button_2
        _btn_following?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _albumNum_label = UILabel(frame:CGRect(x:_btn_album!.frame.origin.x,y:_gapY!+3,width:_btn_album!.frame.width,height:20))
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
        
        
        _label_sex_n_city = UILabel(frame: CGRect(x: _btn_edite!.frame.origin.x, y: _profile_icon_img!.frame.origin.y, width: _myFrame!.width-_btn_edite!.frame.origin.x-_gap!,height: 20))
        _label_sex_n_city?.textColor = Config._color_social_gray
        _label_sex_n_city?.font = Config._font_social_sex_n_city
        
        
        _sign_text = UITextView(frame: CGRect(x: _btn_edite!.frame.origin.x,y: _btn_edite!.frame.origin.y+_btn_edite!.frame.height+4,width: _myFrame!.width-_btn_edite!.frame.origin.x-_gap!,height: 40))
        _sign_text?.font = Config._font_social_sign
        _sign_text?.contentInset = UIEdgeInsetsZero
        _sign_text?.textContainerInset = UIEdgeInsetsZero
        _sign_text?.textAlignment = NSTextAlignment.Left
        _sign_text?.textContainer.lineFragmentPadding=0
        
        
        _sign_text?.textColor = Config._color_social_gray
        _sign_text?.backgroundColor = UIColor.clearColor()
        _sign_text?.editable=false
        //_sign_text?.alpha = 0
        
        
        
        _profilePanel?.addSubview(_profile_icon_img!)
        _profilePanel?.addSubview(_btn_edite!)
        _profilePanel?.addSubview(_btn_share!)
        _profilePanel?.addSubview(_btn_follow!)
        _profilePanel?.addSubview(_btn_message!)
        
        _profilePanel?.addSubview(_followed_label!)
        _profilePanel?.addSubview(_following_label!)
        _profilePanel?.addSubview(_albumNum_label!)
        _profilePanel?.addSubview(_btn_album!)
        _profilePanel?.addSubview(_btn_followed!)
        _profilePanel?.addSubview(_btn_following!)
        
        _profilePanel?.addSubview(_sign_text!)
        _profilePanel?.addSubview(_label_sex_n_city!)
        //----
        
        //---消息提醒----
        
        _messageImg = PicView(frame: CGRect(x: self.view.frame.width - 25 - Config._gap, y: 30, width: 25, height: 25))
        _messageImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _messageImg?.minimumZoomScale=1
        _messageImg?.userInteractionEnabled=false
        _messageImg?.maximumZoomScale=1
        _messageImg?._imgView?.layer.masksToBounds = true
        _messageImg?._imgView?.layer.cornerRadius = 16
        
        
        _messageTap = UITapGestureRecognizer(target: self, action: Selector("messageTapHander:"))
        _messageImg?.addGestureRecognizer(_messageTap!)
        
        _topBar?.addSubview(_messageImg!)
        
        
        //----
        
        _tableView=UITableView()
        
        _tableView?.backgroundColor=UIColor.clearColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: _barH+_profileH+_gap!, width: _myFrame!.width, height: _myFrame!.height-_barH-_profileH-10)
        _tableView?.registerClass(PicAlbumMessageItem.self, forCellReuseIdentifier: "PicAlbumMessageItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        //_tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        _scrollView = UIScrollView(frame: CGRect(x: 0, y: _barH, width: _myFrame!.width, height: _myFrame!.height-_barH))
        
        
        self.view.backgroundColor = Config._color_social_gray_light
        
        _scrollView!.addSubview(_tableView!)
        //_scrollView?.scrollEnabled=true
        
        _scrollView!.addSubview(_profilePanel!)
        
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
        Social_Main._getMessages { (array) -> Void in
            self._hasNewMessage = true            
            self._messageArray = array
            self._messageImg!._setPic((array.objectAtIndex(0) as! NSDictionary).objectForKey("userImg") as? NSDictionary, __block: { (__dict) -> Void in
            })
            
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
        _getUserInfo()
        _getAlbumList()
    }
    
    //------获取相册列表
    func _getAlbumList(){
        Social_Main._getAlbumListAtUser(_userId, __block: { (array) -> Void in
            self._dataArray = array
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self._refreshDatas()
                self._getMessage()
            })
            
            
        })
    }
    //------获取用户信息
    func _getUserInfo(){
        Social_Main._getUserProfileAtId(_userId) { (__dict) -> Void in
            print(__dict)
            self._profileDict = __dict
            self._tableView?.reloadData()
            self._refreshView()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self._title_label?.text=self._profileDict?.objectForKey("nickname") as? String
                self._setAlbumNum(self._profileDict?.objectForKey("albumcounts") as! Int)
                self._setFollowedNum(self._profileDict?.objectForKey("focuscounts") as! Int)
                self._setFollowingNum(self._profileDict?.objectForKey("followcounts") as! Int)
                self._label_sex_n_city?.text = "女，中国 北京"
                //self._setSign(self._profileDict?.objectForKey("signature") as! String)
                self._setSign("搭嘎的送给多少年广东省各地时光都是苹")
            })
        }
    }
    
    //----图册数量
    func _setAlbumNum(__num:Int){
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "图册")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_white_title, range: NSMakeRange(0, attributedString.length) )
        let descString: NSMutableAttributedString = NSMutableAttributedString(string:  " "+String(__num))
        descString.addAttribute(NSForegroundColorAttributeName, value: Config._color_yellow, range: NSMakeRange(0, descString.length))
        attributedString.appendAttributedString(descString)
        _btn_album?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    //----被关注数量
    func _setFollowedNum(__num:Int){
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "被关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_white_title, range: NSMakeRange(0, attributedString.length) )
        let descString: NSMutableAttributedString = NSMutableAttributedString(string:  " "+String(__num))
        descString.addAttribute(NSForegroundColorAttributeName, value: Config._color_yellow, range: NSMakeRange(0, descString.length))
        attributedString.appendAttributedString(descString)
        _btn_followed?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    //-----关注数量
    
    func _setFollowingNum(__num:Int){
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_white_title, range: NSMakeRange(0, attributedString.length) )
        let descString: NSMutableAttributedString = NSMutableAttributedString(string:  " "+String(__num))
        descString.addAttribute(NSForegroundColorAttributeName, value: Config._color_yellow, range: NSMakeRange(0, descString.length))
        attributedString.appendAttributedString(descString)
        _btn_following?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    //----更新数据
    func _refreshDatas(){
        //-----初始化数据
        _allDatasArray = NSMutableArray()
        
        _heighArray=NSMutableArray()
        _commentsArray=NSMutableArray()
        _likeArray = NSMutableArray()
        for var i:Int=0; i<_dataArray.count;++i{
            let _album:NSDictionary = _dataArray.objectAtIndex(i) as! NSDictionary
            
            _allDatasArray?.addObject(NSDictionary(object: _album.objectForKey("_id") as! String, forKey: "_id"))
            
            Social_Main._getPicsListAtAlbumId(_album.objectForKey("_id") as? String, __block: { (array) -> Void in
                
            })
            _heighArray?.addObject(_defaultH)
            //-----获取评论列表
            Social_Main._getCommentsOfAlubm(String(i), block: { (array) -> Void in
                self._commentsArray?.addObject(array)
            })
            //-----获取点赞列表
            Social_Main._getLikesOfAlubm(String(i), block: { (array) -> Void in
                self._likeArray?.addObject(array)
            })
        }
        _tableView?.reloadData()
        self._refreshView()
    }
    func _setSign(__str:String){
        _sign_text!.text=__str
    }
    func _setIconImg(__pic:NSDictionary){
        _profile_icon_img?._setPic(__pic,__block: { (__dict) -> Void in
        })
    }
    
    func _getListHander(__list:NSArray){
        
    }
    //----------------刷新布局
    func _refreshView(){
        
        if _userId == Social_Main._userId{
            _btn_share?.hidden=false
            _btn_edite?.hidden=false
            _btn_follow?.hidden=true
            _btn_message?.hidden=true
            
        }else{
            _btn_share?.hidden=true
            _btn_edite?.hidden=true
            _btn_follow?.hidden=false
            _btn_message?.hidden=false
            _hasNewMessage = false
        }
        if _hasNewMessage{
            _messageImg?.hidden=false
        }else{
            _messageImg?.hidden=true
        }
        _tableView?.frame = CGRect(x: 0, y: _profileH+_gap!, width:  _myFrame!.width, height: _tableView!.contentSize.height)
        _tableView?.scrollEnabled = false
        _scrollView?.contentSize = CGSize(width: _myFrame!.width, height: _tableView!.frame.origin.y+_tableView!.frame.height)
        UIView.commitAnimations()
    }
    //----table 代理
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
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
    
//---------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _dict:NSDictionary = _dataArray.objectAtIndex(indexPath.row) as! NSDictionary
        //print(_dict)
        
        var cell:PicAlbumMessageItem?
        //cell = tableView.viewWithTag(100+indexPath.row) as? PicAlbumMessageItem
        cell = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as? PicAlbumMessageItem
        cell!.setup(CGSize(width: self.view.frame.width, height: _heighArray?.objectAtIndex(indexPath.row) as! CGFloat))
        
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
        //cell!._setPic((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("cover") as! NSDictionary)
        //cell?._setPic(<#T##__pic: NSDictionary##NSDictionary#>)
        
        if let _title:String = _dict.objectForKey("title") as? String{
            cell!._setAlbumTitle(_title)
        }else{
            cell!._setAlbumTitle("")
        }
        if let _des:String = _dict.objectForKey("description") as? String{
            cell!._setDescription(_des)
        }else{
            cell!._setDescription("")
        }
        if let _cover:NSDictionary = _dict.objectForKey("cover") as? NSDictionary{
            cell!._setPic(_cover)
        }else{
            //cell!._setDescription("")
        }
        cell!._setUpdateTime(CoreAction._dateDiff(_dict.objectForKey("last_update_at") as! String))
        if _profileDict != nil{
            
            cell!._setUserImge(NSDictionary(objects: [ MainInterface._imageUrl(_profileDict?.objectForKey("avatar") as! String),"file"], forKeys: ["url","type"]))
            cell!._setUserName(_profileDict!.objectForKey("nickname") as! String)
        }
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
        /*
        if _userId == Social_Main._userId{
            Social_Main._getPicsListAtal(__albumIdex, block: { (array) -> Void in
                let _controller:Social_pic = Social_pic()
                _controller._showIndexAtPics(0, __array: array)
                self.navigationController?.pushViewController(_controller, animated: true)

            })
            return
        }
        
        
*/
        let _album = _dataArray.objectAtIndex(__albumIdex) as! NSDictionary
        Social_Main._getPicsListAtAlbumId(_album.objectForKey("_id") as? String, __block: { (array) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let _controller:Social_pic = Social_pic()
                _controller._showIndexAtPics(0, __array: array)
                self.navigationController?.pushViewController(_controller, animated: true)
            })
        })
        
       
        
    }
    func _viewPicsAtIndex(__array: NSArray, __index: Int) {
        
    }
    func _moreComment(__indexId: Int) {
        let _controller:CommentList = CommentList()
        //println(__dict)
        _controller._dataArray = NSMutableArray(array: (_commentsArray!.objectAtIndex(__indexId) as? NSArray)!)
        self.navigationController?.pushViewController(_controller, animated: true)
    }
    func _moreLike(__indexId: Int) {
        print(__indexId)
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
                if _hasUserInLikesAtIndex(__dict.objectForKey("indexId") as! Int, __userId: Social_Main._currentUser.objectForKey("userId") as! String){
                    return
                }
                let _arr:NSMutableArray = NSMutableArray(array: self._likeArray!)
                let _dict:NSMutableArray = NSMutableArray(array:_arr.objectAtIndex(__dict.objectForKey("indexId") as! Int) as! NSArray)
                let _user:NSDictionary = Social_Main._currentUser as NSDictionary
                _dict.addObject(NSDictionary(objects: [_user.objectForKey("userName") as! String,_user.objectForKey("userId") as! String], forKeys: ["userName","userId"]))
                _arr[__dict.objectForKey("indexId") as! Int] = _dict
                self._likeArray = _arr
                Social_Main._postLike(NSDictionary())
                
                _tableView?.reloadData() //--------使用在线接口时全部请求信息后侦听里面再重新加载
            
            break
            case "comment":
                let _cell:PicAlbumMessageItem = _tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: __dict.objectForKey("indexId") as! Int, inSection: 0)) as! PicAlbumMessageItem
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
              
                let _controller:CommentList = CommentList()
                //println(__dict)
                _controller._dataArray = NSMutableArray(array: (_commentsArray!.objectAtIndex(_cell._indexId) as? NSArray)!)
                
                self.navigationController?.pushViewController(_controller, animated: true)
                
            break
            case "moreAction":
                _currentEditeIndex = __dict.objectForKey("indexId") as? Int
                _openMoreAction()
        default:
            break
        }
        
    }
    //----打开更多的弹出框
    
    func _openMoreAction(){
        if _alerter == nil{
            _alerter = MyAlerter()
            _alerter?._delegate = self
        }
        self.addChildViewController(_alerter!)
        self.view.addSubview(_alerter!.view)
        _alerter?._setMenus(["分享","举报"])
        _alerter?._show()
    }

    //------弹出框代理
    func _myAlerterClickAtMenuId(__id:Int){
        switch __id{
        case 0:
            print(_currentEditeIndex)
            //---分享
            break
        case 1:
            //---举报
            break
        default:
            break
            
        }
    }
    func _myAlerterStartToClose(){
        
    }
    func _myAlerterDidClose(){
        
    }
    func _myAlerterDidShow(){
        
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
        print(__dict.objectForKey("text"))
        _inputer?._close()
    }
    func _inputer_changed(__dict: NSDictionary) {
        print(__dict.objectForKey("text"))
    }
    //-------------
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_edite!:
            print("")
        default:
            print("")
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
            if _naviDelegate != nil{
                _naviDelegate?._cancel()
            }
            self.navigationController?.popViewControllerAnimated(true)
            return
        
        default:
            return
        }
    }
    
    //---打开消息列表
    func _openMessageList(){
        
        let _controller:MessageList = MessageList()
        self.navigationController?.pushViewController(_controller, animated: true)
    }
    
    
}

