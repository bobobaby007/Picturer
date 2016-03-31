//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class MyHomepage: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate, PicAlbumMessageItem_delegate,MyAlerter_delegate,MySettings_delegate,Navi_Delegate{
    
    var _type:String = "my"//"friend/my" //类型，我的主页／朋友的主页
    
    var _barH:CGFloat = 64
    var _myFrame:CGRect?
    var _userId:String = "000001"
    var _userInfo:NSDictionary? //----用户信息
    
    let _space:CGFloat=1.5 //---瀑布流的图片间隔
    
    var _signH:CGFloat?
    var _title_label:UILabel?
    var _frameW:CGFloat?
    var _gap:CGFloat?
    var _gapY:CGFloat?
    var _imgW:CGFloat?
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    var _alertType:String = "myPage"  //---弹出提示按钮的类型 myPage / album
    
    
    var _collectionLayout:UICollectionViewFlowLayout?
    var _imagesCollection:UICollectionView?
    
    
    var _dataArray:NSArray=[]
    var _setuped:Bool = false
    
    
    
    var _profilePanel:UIView?
    var _user_img:PicView?
    var _btn_edite:UIButton?
    var _btn_moreAction:UIButton?
    var _btn_follow:UIButton?
    var _sign_text:UILabel?
    var _line_profile:UIView?
    
    
    var _label_sex_n_city:UILabel?
    
    
    var _btn_followed:UIButton?//----被关注
    var _btn_following:UIButton?//----关注
    var _btn_album:UIButton?
    
    var _profileH:CGFloat = 153//-----面板高度
    var _buttonH:CGFloat = 30 //---按钮高度
    var _buttonW:CGFloat = 125//---按钮宽度
    var _buttonGap:CGFloat = 0.5 //---按钮间距
    
    var _scrollView:UIScrollView?
    
    var _focused:Bool = false //----是否关注过
    
    
    var _allDatasArray:NSMutableArray? //------其他信息，以相册id为锚点
    var _coverArray:NSMutableArray?
    var _imagesArray:NSMutableArray?//-----每个相册里的图片
    var _heighArray:NSMutableArray?
    var _commentsArray:NSMutableArray?
    var _likeArray:NSMutableArray?//---点赞数
    var _likedArray:NSMutableArray?//----点过赞
    
    var _collectedArray:NSMutableArray?//---收藏过
    
    var _defaultH:CGFloat = 632
    
    var _scrollTopH:CGFloat = 0 //达到这个高度时向上移动
    
    var _inputer:Inputer?
    
    var _viewIned:Bool? = false
    
    var _messageTap:UITapGestureRecognizer?
    var _messageImg:PicView?
    
    var _btn_changeShowType:UIButton? //----是朋友的切换瀑布流方式
    var _showType:String = "pic"// －－－－－图片展示方式 pic/collection
    
    var _hasNewMessage:Bool = false
    var _messageArray:NSArray?
    weak var _naviDelegate:Navi_Delegate?
    
    
    var _alerter:MyAlerter?
    var _currentEditeIndex:Int?
    
    var _allLikeIcon:UIImageView?
    var _allLikeLabel:UILabel?
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets=false
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    
        setup(self.view.frame)
        
        
    }
    
    func setup(__frame:CGRect){
        if _setuped {
            return
        }
        _myFrame = __frame
        _frameW = _myFrame!.width
        _gap = 15
        _gapY = 0.06*_frameW!
        _imgW = 75//0.20*_frameW!
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
        
        _user_img = PicView(frame: CGRect(x: _gap!, y: _gapY!, width: _imgW!, height: _imgW!))
        _user_img?.scrollEnabled=false
        _user_img?.minimumZoomScale=1
        _user_img?.maximumZoomScale=1
        _user_img?._imgView?.contentMode=UIViewContentMode.ScaleAspectFill
        _user_img?._imgView?.layer.masksToBounds=true
        _user_img?._imgView?.layer.cornerRadius = 0.5*_user_img!.frame.width
        
        _btn_edite = UIButton(frame: CGRect(x: _gap!+_user_img!.frame.width+_gap!,y: _user_img!.frame.origin.y+20,width: 2*0.33*(_frameW!-_gap!-_gap!-_imgW!),height: 30))
        _btn_edite?.backgroundColor = UIColor(white: 1, alpha: 1)
        _btn_edite?.layer.borderWidth = 1
        _btn_edite?.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        _btn_edite?.layer.masksToBounds = true
        _btn_edite?.layer.cornerRadius = 5
        var attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "编辑个人主页")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_social_gray, range: NSMakeRange(0, attributedString.length))
        _btn_edite?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_edite?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_edite?.titleLabel?.font=Config._font_social_button
        _btn_edite?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_moreAction = UIButton(frame: CGRect(x: _btn_edite!.frame.origin.x+_btn_edite!.frame.width+3,y: _btn_edite!.frame.origin.y,width: _frameW!-_btn_edite!.frame.origin.x-_btn_edite!.frame.width-3-_gap!,height: _btn_edite!.frame.height))
        
        _btn_moreAction?.backgroundColor = UIColor(white: 1, alpha: 1)
        _btn_moreAction?.layer.borderWidth = 1
        _btn_moreAction?.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        _btn_moreAction?.layer.masksToBounds = true
        _btn_moreAction?.layer.cornerRadius = 5
        _btn_moreAction?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "更多")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_social_gray, range: NSMakeRange(0, attributedString.length))
        _btn_moreAction?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_moreAction?.titleLabel?.font=Config._font_social_button
        _btn_moreAction?.addTarget(self, action: #selector(MyHomepage.btnHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        _btn_follow = UIButton(frame: CGRect(x: _gap!+_user_img!.frame.width+_gap!,y: _user_img!.frame.origin.y+20,width: 2*0.33*(_frameW!-_gap!-_gap!-_imgW!),height: 30))
        _btn_follow?.backgroundColor = UIColor(white: 1, alpha: 1)
        _btn_follow?.layer.borderWidth = 1
        _btn_follow?.layer.borderColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1).CGColor
        _btn_follow?.layer.masksToBounds = true
        _btn_follow?.layer.cornerRadius = 5
        attributedString = NSMutableAttributedString(string: "＋关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_social_gray, range: NSMakeRange(0, attributedString.length))
        _btn_follow?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_follow?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_follow?.titleLabel?.font=Config._font_social_button
        _btn_follow?.addTarget(self, action: #selector(MyHomepage.btnHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_album = UIButton(frame: CGRect(x: 0,y: _profileH - _buttonH,width: _buttonW,height: _buttonH))
        _btn_album?.backgroundColor = Config._color_black_title
        _btn_album?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "图册")
       // attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_album?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_album?.setTitleColor(Config._color_white_title, forState: UIControlState.Normal)
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
        _btn_followed?.addTarget(self, action: #selector(MyHomepage.btnHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_following = UIButton(frame: CGRect(x: _btn_album!.frame.origin.x + 2*_buttonW + 2*_buttonGap,y: _btn_album!.frame.origin.y,width: _buttonW,height: _buttonH))
        _btn_following?.backgroundColor = Config._color_black_title
        _btn_following?.titleLabel?.textAlignment = NSTextAlignment.Center
        attributedString = NSMutableAttributedString(string: "关注")
        attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        _btn_following?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        _btn_following?.setTitleColor(Config._color_white_title, forState: UIControlState.Normal)
        _btn_following?.titleLabel?.font=Config._font_social_button_2
        _btn_following?.addTarget(self, action: #selector(MyHomepage.btnHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        _label_sex_n_city = UILabel(frame: CGRect(x: _btn_edite!.frame.origin.x, y: _user_img!.frame.origin.y-3, width: _myFrame!.width-_btn_edite!.frame.origin.x-_gap!,height: 20))
        _label_sex_n_city?.textColor = Config._color_social_gray
        _label_sex_n_city?.font = Config._font_social_sex_n_city
        
        
        _sign_text = UILabel(frame: CGRect(x: _btn_edite!.frame.origin.x,y: _btn_edite!.frame.origin.y+_btn_edite!.frame.height+2,width: _myFrame!.width-_btn_edite!.frame.origin.x-_gap!,height: 30))
        
        
       // _sign_text?.contentInset = UIEdgeInsetsZero
        //_sign_text?.textContainerInset = UIEdgeInsetsZero
        
        _sign_text?.textAlignment = NSTextAlignment.Left
        //_sign_text?.textContainer.lineFragmentPadding=0
        _sign_text?.backgroundColor = UIColor.clearColor()
        //_sign_text?.editable=false
        //_sign_text?.alpha = 0
        
        
        
        _profilePanel?.addSubview(_user_img!)
        _profilePanel?.addSubview(_btn_edite!)
        _profilePanel?.addSubview(_btn_moreAction!)
        _profilePanel?.addSubview(_btn_follow!)
        
       
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
        
        _messageImg?.maximumZoomScale=1
        _messageImg?._imgView?.layer.masksToBounds = true
        _messageImg?._imgView?.layer.cornerRadius = 12.5
        
        
        _messageTap = UITapGestureRecognizer(target: self, action: Selector("messageTapHander:"))
        _messageImg?.addGestureRecognizer(_messageTap!)
        
        _topBar?.addSubview(_messageImg!)
        
        
        //----切换展示方式按钮
        _btn_changeShowType = UIButton(frame: CGRect(x: self.view.frame.width - 18 - Config._gap, y: 34, width: 18, height: 18))
        _btn_changeShowType?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _topBar?.addSubview(_btn_changeShowType!)
        
        
        //---
        _tableView=UITableView()
        
        _tableView?.backgroundColor=UIColor.clearColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: _profileH+_gap!, width: _myFrame!.width, height: _myFrame!.height-_barH-_profileH-10)
        _tableView?.registerClass(PicAlbumMessageItem.self, forCellReuseIdentifier: "PicAlbumMessageItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        //_tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        _scrollView = UIScrollView(frame: CGRect(x: 0, y: _barH, width: _myFrame!.width, height: _myFrame!.height-_barH))
        
        
        
        
        _collectionLayout=UICollectionViewFlowLayout()
        let _imagesW:CGFloat=(self.view.frame.width-2*_space)/3
        //let _imagesH:CGFloat=ceil(CGFloat(_picsArray!.count)/4)*(_imagesW+_space)
        
        _collectionLayout?.minimumInteritemSpacing=_space
        _collectionLayout?.minimumLineSpacing=_space
        _collectionLayout!.itemSize=CGSize(width: _imagesW, height: _imagesW)
        
        _imagesCollection=UICollectionView(frame: CGRect(x: 0, y: _tableView!.frame.origin.y, width: self.view.frame.width, height: self.view.frame.width-_barH), collectionViewLayout: _collectionLayout!)
        
        //_imagesCollection?.frame=CGRect(x: _gap, y: _buttonH+2*_gap, width: self.view.frame.width-2*_gap, height: _imagesH)
        
        _imagesCollection?.backgroundColor=UIColor.clearColor()
        _imagesCollection!.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        
        _imagesCollection?.delegate=self
        _imagesCollection?.dataSource=self
        
        
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
        self._checkType()
        
        _setuped=true
    }
    //提取数据
    func _getMessage(){
        Social_Main._getMessages { (array) -> Void in
            self._hasNewMessage = true            
            self._messageArray = array
            do{
              self._messageImg!._setPic(((array.objectAtIndex(0) as! NSDictionary).objectForKey("userImg") as? NSDictionary)!, __block: { (__dict) -> Void in
                })
            }
            //self._refreshView()
        }
    }
    //----消息按钮侦听
    func messageTapHander(__sender:UITapGestureRecognizer){
        print("点击")
        _hasNewMessage = false
        _refreshView()
        _openMessageList()
    }
    func _getDatas(){
        _getUserInfo()
        _getAlbumList()
        
        //_FocusUser()
//        Social_Main._focusToUser("56dae76f3949ed957b28d9f1") { (__dict) -> Void in
//            print("关注成功",__dict)
//        }
//        Social_Main._getMyFocusList(_userId, __block: { (__dict) -> Void in
//            //print("_getMyFocusList：",__dict)
//        })
    }
    //------获取相册列表
    func _getAlbumList(){
        Social_Main._getAlbumListAtUser(_userId, __block: { (array) -> Void in
            self._dataArray = array
            
            //print("相册列表：",array,"======")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self._refreshDatas()
                self._getMessage()
            })
        })
    }
    //------获取用户信息
    func _getUserInfo(){
        Social_Main._getUserProfileAtId(_userId) { (__dict) -> Void in
            //print(__dict)
            dispatch_async(dispatch_get_main_queue(), { [weak self]() -> Void in
                self?._getUserInfoOk(__dict)
            })
        }
    }
    
    func _getUserInfoOk(__dict:NSDictionary){
        

        
        
        self._userInfo = __dict
        self._title_label?.text=self._userInfo?.objectForKey("nickname") as? String
        self._setAlbumNum(self._userInfo?.objectForKey("albumcounts") as! Int)
        self._setFollowedNum(self._userInfo?.objectForKey("followcounts") as! Int)
        self._setFollowingNum(self._userInfo?.objectForKey("focuscounts") as! Int)
        self._setIconImg(MainInterface._userAvatar(self._userInfo!))
        var _sexStr:String = ""
        if let _s:Int = self._userInfo?.objectForKey("sex") as? Int{
            if _sexStr != ""{
                _sexStr = MainInterface._sexStr(_s)+"，"
            }
        }
        
        
        
        if let _Ifocus:NSDictionary = __dict.objectForKey("Ifocus") as? NSDictionary{
            print("是否互相关注",_Ifocus)
            if let _each = _Ifocus.objectForKey("each") as? Int{
                switch _each{
                case 0://---未关注
                    _setFocused(false)
                    break
                case 1:
                    _setFocused(true)
                    break
                
                default:
                    break
                }
                
            }
        }else{
            if _type == "me"{
                
            }else{
                _setFocused(false)
            }
        }
        
        
        
        self._label_sex_n_city?.text = "\(_sexStr)中国 北京"
        if let _str:String = self._userInfo?.objectForKey("signature") as? String{
            self._setSign(_str)
        }
        self._refreshView()
    }
    //------关注用户
    func _FocusUser(){
        Social_Main._focusToUser(_userId) { (__dict) -> Void in
            print(__dict)
        }
        _setFocused(true)
    }
    //------取消关注用户
    func _cancelFocusUser(){
        Social_Main._cancelFocusToUser(_userId) { (__dict) -> Void in
            print(__dict)
        }
        _setFocused(false)
    }
    
    //----图册数量
    func _setAlbumNum(__num:Int){
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "图册")
        //attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_white_title, range: NSMakeRange(0, attributedString.length) )
        if __num > 0{
            let descString: NSMutableAttributedString = NSMutableAttributedString(string:  " "+String(__num))
            descString.addAttribute(NSForegroundColorAttributeName, value: Config._color_yellow, range: NSMakeRange(0, descString.length))
            attributedString.appendAttributedString(descString)
        }
        _btn_album?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    //----被关注数量
    func _setFollowedNum(__num:Int){
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "被关注")
        //attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_white_title, range: NSMakeRange(0, attributedString.length) )
        if __num > 0{
            let descString: NSMutableAttributedString = NSMutableAttributedString(string:  " "+String(__num))
            descString.addAttribute(NSForegroundColorAttributeName, value: Config._color_yellow, range: NSMakeRange(0, descString.length))
            attributedString.appendAttributedString(descString)
        }
        _btn_followed?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    //-----关注数量
    func _setFollowingNum(__num:Int){
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: "关注")
        //attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_white_title, range: NSMakeRange(0, attributedString.length) )
        if __num > 0{
            let descString: NSMutableAttributedString = NSMutableAttributedString(string:  " "+String(__num))
            descString.addAttribute(NSForegroundColorAttributeName, value: Config._color_yellow, range: NSMakeRange(0, descString.length))
            attributedString.appendAttributedString(descString)
        }
        _btn_following?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    //----更新数据
    func _refreshDatas(){
        //-----初始化数据
        _allDatasArray = NSMutableArray()
        _heighArray=NSMutableArray()
        _commentsArray=NSMutableArray()
        _likeArray = NSMutableArray()
        _likedArray =  NSMutableArray()
        _collectedArray = NSMutableArray()
        
        
        for var i:Int=0; i<_dataArray.count;++i{
            
            let _album:NSDictionary = _dataArray.objectAtIndex(i) as! NSDictionary
            
            if let _album_id = _album.objectForKey("_id") as? String{
                _allDatasArray?.addObject(NSDictionary(object: _album_id, forKey: "_id"))
//                Social_Main._getPicsListAtAlbumId(_album_id, __block: { (array) -> Void in
//                    
//                })
                
            }else{
                _allDatasArray?.addObject(NSDictionary(object: "", forKey: "_id"))
            }
            
            
            
            _heighArray?.addObject(_defaultH)
            
            
            
            //---点赞数
            if let _likeNum = _album.objectForKey("likes") as? Int{
                self._likeArray?.addObject(_likeNum)
            }else{
                self._likeArray?.addObject(0)
            }
            //----是否点过赞
            self._likedArray?.addObject(false)
            //---是否收藏过
            self._collectedArray?.addObject(false)
            
        }
        _tableView?.reloadData()
        self._refreshView()
    }
    func _setSign(__str:String){
        
        
        let attributedString = NSMutableAttributedString(string: __str)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_social_gray, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(NSKernAttributeName, value: 0.25, range: NSMakeRange(0, attributedString.length) )
        attributedString.addAttribute(NSFontAttributeName, value: Config._font_social_sign, range: NSMakeRange(0, attributedString.length))
        
        _sign_text!.attributedText = attributedString
        
//        _sign_text?.font = Config._font_social_sign
//        _sign_text?.textColor = Config._color_social_gray
//        _sign_text?.text = __str
    }
    
    //---用户头像
    
    func _setIconImg(__pic:NSDictionary){
        _user_img?._setPic(__pic,__block: { (__dict) -> Void in
        })
    }
    
    func _getListHander(__list:NSArray){
        
    }
    
    //----编辑代理
    func _setting_saved() {
        //_getUserInfo()
        _getDatas()
    }
    func _setting_back(){
        //_getUserInfo()
    }
    //--------类型判断并设定，是自己的个人主页还是查看别人的个人主页
    func _checkType(){
        if _userId == Social_Main._userId{
            _type = "my"
            _btn_moreAction?.hidden=false
            _btn_edite?.hidden=false
            _btn_follow?.hidden=true
            _messageImg?.hidden = false
            _btn_changeShowType?.hidden=true
        }else{
            _type = "friend"
            _btn_moreAction?.hidden=false
            _btn_edite?.hidden=true
            _btn_follow?.hidden=false
            _messageImg?.hidden = true
            _btn_changeShowType?.hidden=false
            //_hasNewMessage = false
        }
        _changeTo("pic")
    }
    
    //----设置是否关注过
    func _setFocused(__yes:Bool){
        _focused = __yes
        
        if __yes{
            
            let attributedString = NSMutableAttributedString(string: "已关注")
            attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_social_gray, range: NSMakeRange(0, attributedString.length))
            _btn_follow?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
            _btn_follow?.backgroundColor = Config._color_yellow
            _btn_follow?.layer.borderWidth = 0
            
        }else{
            let attributedString = NSMutableAttributedString(string: "＋关注")
            attributedString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attributedString.length) )
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Config._color_social_gray, range: NSMakeRange(0, attributedString.length))
            _btn_follow?.setAttributedTitle(attributedString, forState: UIControlState.Normal)
            _btn_follow?.backgroundColor = UIColor.whiteColor()
            _btn_follow?.layer.borderWidth = 1
        }
        
    }
    
    //-----切换查看模式，瀑布流或单张
    func _changeTo(__type:String){
        
        _showType = __type
        switch _showType{
        case "pic"://单张
            _imagesCollection?.removeFromSuperview()
            _scrollView?.addSubview(_tableView!)
            _btn_changeShowType?.setImage(UIImage(named: "changeToCollect_icon_yellow.png"), forState: UIControlState.Normal)
            
            break
        case "collection":
            _tableView?.removeFromSuperview()
            _scrollView?.addSubview(_imagesCollection!)
            _btn_changeShowType?.setImage(UIImage(named: "changeToPic.png"), forState: UIControlState.Normal)
            break
        default:
            break
            
        }
        
        _refreshView()
    }
    
    //----------------刷新布局
    func _refreshView(){
        
        //UIView.beginAnimations("refreshView", context: nil)
        
        if _hasNewMessage{
        }else{
            self._messageImg?._setImage("messageBtnIcon")
        }
//        _tableView?.frame = CGRect(x: 0, y: _profileH+_gap!, width:  _myFrame!.width, height: _tableView!.contentSize.height)
//        _tableView?.scrollEnabled = false
//        _scrollView?.contentSize = CGSize(width: _myFrame!.width, height: _tableView!.frame.origin.y+_tableView!.frame.height)
        
        
        switch _showType{
        case "pic":
            //_tableView?.reloadData()
            _tableView?.frame = CGRect(x: 0, y: _profileH+_gap!, width:  _myFrame!.width, height: _tableView!.contentSize.height)
            _tableView?.scrollEnabled = false
            _scrollView?.contentSize = CGSize(width: _myFrame!.width, height: _tableView!.frame.origin.y+_tableView!.frame.height)
            
            break
        case "collection":
            _imagesCollection?.reloadData()
            let _imagesW:CGFloat=(self.view.frame.width-2*_space)/3
            let _h:CGFloat = CGFloat(ceil(CGFloat(_dataArray.count)/3))*(_imagesW+_space)
            
            _imagesCollection?.frame = CGRect(x: 0, y: _profileH+_gap!, width:  self.view.frame.width, height: _h)
            _imagesCollection?.scrollEnabled = false
            _scrollView?.contentSize = CGSize(width: self.view.frame.width, height: _imagesCollection!.frame.origin.y+_imagesCollection!.frame.height)
            break
        default:
            break
        }
        
        //UIView.commitAnimations()
        
    }
    
    //-----瀑布流代理
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _dataArray.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        _viewAlbum(indexPath.row)
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "PicsShowCell"
        let cell = self._imagesCollection?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! PicsShowCell
        
        
        let _dict:NSDictionary = _dataArray.objectAtIndex(indexPath.row) as! NSDictionary
        
        
        if let _cover:NSDictionary = _dict.objectForKey("cover") as? NSDictionary{
            cell._setPic(_cover)
        }else{
            //cell!._setDescription("")
        }
        
        
        //cell._setPic(_pic)
        return cell
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
        
        if  _heighArray == nil{
            _refreshDatas()
        }
        
        if _heighArray!.count>=indexPath.row+1{
            return CGFloat(_heighArray!.objectAtIndex(indexPath.row) as! NSNumber)
        }
        //println(_heighArray.objectAtIndex(indexPath.row))
        return 700
    }
    
//---------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _dict:NSDictionary = _dataArray.objectAtIndex(indexPath.row) as! NSDictionary
        print("相册:",_dict)
        
        var cell:PicAlbumMessageItem?
        //cell = tableView.viewWithTag(100+indexPath.row) as? PicAlbumMessageItem
        cell = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as? PicAlbumMessageItem
        
        cell!.setup(CGSize(width: self.view.frame.width, height: _heighArray?.objectAtIndex(indexPath.row) as! CGFloat))
        
        cell!.separatorInset = UIEdgeInsetsZero
        cell!.preservesSuperviewLayoutMargins = false
        cell!.layoutMargins = UIEdgeInsetsZero
        //cell!.tag = 100+indexPath.row
//        let _array:NSArray = _commentsArray?.objectAtIndex(indexPath.row) as! NSArray
//        cell!._setComments(_array, __allNum: _array.count)
        
        
        
        
        cell!._setLikeNum(self._likeArray?.objectAtIndex(indexPath.row) as! Int)
        cell?._setLiked(_hasLikedAtIndex(indexPath.row))
        cell?._setCollected(_hasCollectdAtIndex(indexPath.row))
        
        cell!._userId = _userId
        cell!._indexId = indexPath.row
        cell!._delegate=self
        //cell!._setPic((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("cover") as! NSDictionary)
        //cell?._setPic(<#T##__pic: NSDictionary##NSDictionary#>)
        
        if let _title:String = _dict.objectForKey("title") as? String{
            cell!._setAlbumTitle(_title,__num: _dict.objectForKey("counts") as! Int)
        }else{
            cell!._setAlbumTitle("",__num: _dict.objectForKey("counts") as! Int)
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
        if _userInfo != nil{
            cell!._setUserImge(MainInterface._userAvatar(_userInfo!))
            cell!._setUserName(_userInfo!.objectForKey("nickname") as! String)
        }
        if let _comments:NSArray = _dict.objectForKey("comment") as? NSArray{
            cell!._setComments(_comments, __allNum: _dict.objectForKey("comments") as! Int)
            //cell!._setComments(_comments, __allNum: _dict.objectForKey("comments") as! Int)
        }
        
        //cell!._refreshView()
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("选择")
    }
    //------相册单元代理
    func _resized(__indexId: Int, __height: CGFloat) {
        //println("changeH")
        
        var _lastH:CGFloat? = -10
        if _heighArray!.count>=__indexId+1{
         _lastH = CGFloat(_heighArray!.objectAtIndex(__indexId) as! NSNumber)
        }
        if _lastH != __height{
            _heighArray![__indexId] = __height
            //_tableView?.reloadRowsAtIndexPaths( [NSIndexPath(forRow: __indexId, inSection: 0)] , withRowAnimation: UITableViewRowAnimation.None)
            _refreshView()
        }
        
       // println(_heighArray)
    }
    
    //---进入查看相册
    func _viewAlbum(__albumIdex:Int) {
        
        let _album = _dataArray.objectAtIndex(__albumIdex) as! NSDictionary
        
        if _userId == Social_Main._userId{ //-----如果是本人
            
            Social_Main._getImagesOfAlbumIndex(__albumIdex, __block: {[weak self] (array) -> Void in
                if array.count<=0{
                    print("没有图片")
                    return
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self != nil{
                        let _controller:Social_pic = Social_pic()
                        _controller._titleBase = _album.objectForKey("title") as! String
                        _controller._showIndexAtPics(0, __array: array)
                        self?.navigationController?.pushViewController(_controller, animated: true)
                    }
                })
                })
            return
        }
        Social_Main._getPicsListAtAlbumId(_album.objectForKey("_id") as? String, __block: { [weak self] (array) -> Void in
            if array.count<=0{
                print("没有图片")
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self != nil{
                    let _controller:Social_pic = Social_pic()
                    _controller._titleBase = _album.objectForKey("title") as! String
                    _controller._showIndexAtPics(0, __array: array)
                    self?.navigationController?.pushViewController(_controller, animated: true)
                }
            })
        })
    }
    func _viewAlbumDetail(__albumIndex: Int) {
        
    }
    func _viewPicsAtIndex(__array: NSArray, __index: Int) {
        
    }
    func _moreComment(__indexId: Int) {
        let _controller:CommentList = CommentList()
        _controller._type = CommentList._Type_album
        let _dict = _dataArray.objectAtIndex(__indexId) as! NSDictionary
        _controller._id = _dict.objectForKey("_id") as! String
        //println(__dict)
        //_controller._dataArray = NSMutableArray(array: (_commentsArray!.objectAtIndex(__indexId) as? NSArray)!)
        self.navigationController?.pushViewController(_controller, animated: true)
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
                if _hasLikedAtIndex(__dict.objectForKey("indexId") as! Int){
                    _removeLikeAtIndex(__dict.objectForKey("indexId") as! Int)
                }else{
                    _addLikeAtIndex(__dict.objectForKey("indexId") as! Int)
                }
                
            break
            case "collect":
                if _hasCollectdAtIndex(__dict.objectForKey("indexId") as! Int){
                    _removeCollectAtIndex(__dict.objectForKey("indexId") as! Int)
                }else{
                    _addCollectAtIndex(__dict.objectForKey("indexId") as! Int)
                }
            
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
                _controller._type = CommentList._Type_album
                let _dict = _dataArray.objectAtIndex(__dict.objectForKey("indexId") as! Int) as! NSDictionary
                _controller._id = _dict.objectForKey("_id") as! String
                //println(__dict)
                //_controller._dataArray = NSMutableArray(array: (_commentsArray!.objectAtIndex(_cell._indexId) as? NSArray)!)
                
                self.navigationController?.pushViewController(_controller, animated: true)
                
            break
            case "moreAction":
                _currentEditeIndex = __dict.objectForKey("indexId") as? Int
                _openMoreAction()
            case "moreLike":
                let _controller:LikeList = LikeList()
                //println(__dict)
                _controller._dataArray = NSMutableArray(array: (_likeArray!.objectAtIndex(__dict.objectForKey("indexId") as! Int) as? NSArray)!)
                self.navigationController?.pushViewController(_controller, animated: true)
        default:
            break
        }
        
    }
    
    //----添加点赞
    
    func _addLikeAtIndex(__index:Int){
        if _hasLikedAtIndex(__index){
            return
        }
        let _arr:NSMutableArray = NSMutableArray(array: self._likedArray!)
        _arr[__index] = true
        self._likedArray = _arr
        
        
        let _arr2:NSMutableArray = NSMutableArray(array: self._likeArray!)
        let _n:Int = _arr2.objectAtIndex(__index) as! Int
        _arr2[__index] = _n+1
        self._likeArray = _arr2
        
        do{
            let _dict:NSDictionary = _dataArray.objectAtIndex(__index) as! NSDictionary
            MainInterface._likeAlbum(_dict.objectForKey("_id") as! String, __block: { (__dict) -> Void in
                print("成功：",__dict)
            })
        }
        //
        
        // Social_Main._postLike(NSDictionary())
        
        _tableView?.reloadData() //--------使用在线接口时全部请求信息后侦听里面再重新加载
    }
    //----取消点赞
    
    func _removeLikeAtIndex(__index:Int){
        if _hasLikedAtIndex(__index){
            
        }else{
            return
        }
        let _arr:NSMutableArray = NSMutableArray(array: self._likedArray!)
        _arr[__index] = false
        self._likedArray = _arr
        
        
        let _arr2:NSMutableArray = NSMutableArray(array: self._likeArray!)
        let _n:Int = _arr2.objectAtIndex(__index) as! Int
        _arr2[__index] = _n-1
        self._likeArray = _arr2
        
        do{
            let _dict:NSDictionary = _dataArray.objectAtIndex(__index) as! NSDictionary
            MainInterface._unlikeAlbum(_dict.objectForKey("_id") as! String, __block: { (__dict) -> Void in
                print("成功：",__dict)
            })
        }
        //
        
        // Social_Main._postLike(NSDictionary())
        
        _tableView?.reloadData() //--------使用在线接口时全部请求信息后侦听里面再重新加载
    }
    
    //---添加收藏
    func _addCollectAtIndex(__index:Int){
        if _hasCollectdAtIndex(__index){
            return
        }
        let _arr:NSMutableArray = NSMutableArray(array: self._collectedArray!)
        _arr[__index] = true
        self._collectedArray = _arr
        
        let _dict:NSDictionary = _dataArray.objectAtIndex(__index) as! NSDictionary
        MainInterface._collectAlbum(_dict.objectForKey("_id") as! String, __block: { (__dict) -> Void in
            //print("添加收藏成功：",__dict)
        })
        _tableView?.reloadData() //--------使用在线接口时全部请求信息后侦听里面再重新加载
    }
    //----取消收藏
    func _removeCollectAtIndex(__index:Int){
        if _hasCollectdAtIndex(__index){
            
        }else{
            return
        }
        let _arr:NSMutableArray = NSMutableArray(array: self._collectedArray!)
        _arr[__index] = false
        self._collectedArray = _arr
        
        //        let _dict:NSDictionary = _dataArray.objectAtIndex(__index) as! NSDictionary
        //        MainInterface._likeAlbum(_dict.objectForKey("_id") as! String, __block: { (__dict) -> Void in
        //            print("成功：",__dict)
        //        })
        _tableView?.reloadData() //--------使用在线接口时全部请求信息后侦听里面再重新加载
    }
    
    //----打开更多的弹出框－－－单张的代理
    
    func _openMoreAction(){
        if _alerter == nil{
            _alerter = MyAlerter()
            _alerter?._delegate = self
        }
        self.addChildViewController(_alerter!)
        self.view.addSubview(_alerter!.view)
        _alerter?._setMenus(["分享","举报"])
        _alertType = "album"
        _alerter?._show()
    }

    //----－整个主页的更多按钮弹出
    func _openMoreActionForMyPage(){
        if _alerter == nil{
            _alerter = MyAlerter()
            _alerter?._delegate = self
        }
        self.addChildViewController(_alerter!)
        self.view.addSubview(_alerter!.view)
        _alerter?._setMenus(["分享","举报"])
        _alertType = "myPage"
        _alerter?._show()
    }
    
    //------弹出框代理
    func _myAlerterClickAtMenuId(__id:Int){
        
        switch _alertType{
            case "alum":
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
    
    
    
    
    
    //----判断是否已经有点过赞
    
    func _hasLikedAtIndex(__indexId:Int)->Bool{
        
        if __indexId>=self._likedArray?.count{
            return false
        }
        
        if (self._likedArray![__indexId] as? Bool) ==  true {
            return true
        }
        return false
    }
    //----判断是否收藏过
    func _hasCollectdAtIndex(__indexId:Int)->Bool{
        if __indexId>=self._collectedArray?.count{
            return false
        }
        if (self._collectedArray![__indexId] as? Bool) ==  true {
            return true
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
            let _setting:MySettings = MySettings()
            _setting._delegate=self
            _setting._userInfo = _userInfo!
            self.navigationController?.pushViewController(_setting, animated: true)
            break
        case _btn_followed!:
            let _contr:FocusMeList=FocusMeList()
            _contr._type = FocusMeList._Type_FocusMe
            _contr._uid = _userId
            _contr._naviDelegate = self
            self.navigationController?.pushViewController(_contr, animated: true)
            break
            
        case _btn_follow!: //---关注该用户的按钮
            if _focused{
                _cancelFocusUser()
            }else{
                _FocusUser()
            }
            break
            
        case _btn_following!:
            let _contr:FocusMeList=FocusMeList()
            _contr._type = FocusMeList._Type_Focus
            _contr._uid = _userId
            _contr._naviDelegate = self
            self.navigationController?.pushViewController(_contr, animated: true)
            break
        case _btn_moreAction!:
            _openMoreActionForMyPage()
            break
        default:
            print("")
        }
    }
    
    //----返回代理
    func _cancel() {
        
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        //setup(<#__frame: CGRect#>)
        
        
        //_setSign(_userInfo!.objectForKey("sign") as! String)
        //_setIconImg(_userInfo!.objectForKey("profileImg") as! NSDictionary)
    }
    override func viewDidAppear(animated: Bool) {
        if _viewIned!{
            
        }else{
           
            _viewIned=true
        }
        ImageLoader.sharedLoader._removeAllTask()
        _getDatas()
        
    }
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            if _naviDelegate != nil{
                _naviDelegate?._cancel()
            }
            self.navigationController?.popViewControllerAnimated(true)
            return
        case _btn_changeShowType!:
            switch _showType{
            case "pic":
                _changeTo("collection")
                return
            case "collection":
                _changeTo("pic")
                return
            default:
                return
                
            }

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

