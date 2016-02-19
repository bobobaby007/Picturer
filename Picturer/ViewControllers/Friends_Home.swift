//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class Friends_Home: UIViewController, UITableViewDataSource, UITableViewDelegate, PicAlbumMessageItem_delegate,MyAlerter_delegate{
    
    var _type:String = "friends"//"friends/likes" //类型，朋友/妙人
    
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
    
    var _userInfo:NSDictionary?
    
    var _profile_icon_img:PicView?
    var _btn_edite:UIButton?
    var _btn_share:UIButton?
    var _btn_follow:UIButton?
    var _btn_message:UIButton?
   
    
    
    
    
    var _profileH:CGFloat = 0//-----面板高度
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
        
        
        
        //---消息提醒----
        
        _messageImg = PicView(frame: CGRect(x: self.view.frame.width - 25 - Config._gap, y: 30, width: 25, height: 25))
        _messageImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _messageImg?.minimumZoomScale=1
        _messageImg?.userInteractionEnabled=false
        _messageImg?.maximumZoomScale=1
        _messageImg?._imgView?.layer.masksToBounds = true
        _messageImg?._imgView?.layer.cornerRadius = 12.5
        
        
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
            self._messageImg!._setPic(((array.objectAtIndex(0) as! NSDictionary).objectForKey("userImg") as? NSDictionary)!, __block: { (__dict) -> Void in
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
       
        _getAlbumList()
        
    }
    
    //------获取内容树列表
    func _getAlbumList(){
//        Social_Main._getAlbumListAtUser(MainInterface._uid, __block: { (array) -> Void in
//            self._dataArray = array
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self._refreshDatas()
//                self._getMessage()
//            })
//            
//        })
//        
//        return
        
        switch _type{
            case "friends":
            break
        case "likes":
            Social_Main._getMyFocusTimeLine({ (array) -> Void in
                self._dataArray = array
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self._refreshDatas()
                    self._getMessage()
                })
                
            })
            break
        default:
            break
        }
    }
    
    
    //----更新数据
    func _refreshDatas(){
        //-----初始化数据
        _allDatasArray = NSMutableArray()
        
        _heighArray=NSMutableArray()
        _commentsArray=NSMutableArray()
        _likeArray = NSMutableArray()
        //---解析获取到的数据
        for var i:Int=0; i<_dataArray.count;++i{
            let _dict:NSDictionary = _dataArray.objectAtIndex(i) as! NSDictionary
            
            _allDatasArray?.addObject(NSDictionary(object: _dict.objectForKey("_id") as! String, forKey: "_id"))
            _heighArray?.addObject(_defaultH)
            //-----评论列表
            
            self._commentsArray?.addObject(_dict.objectForKey("comments") as! NSArray)
            
            //-----获取点赞列表
            self._likeArray?.addObject(_dict.objectForKey("likes") as! NSArray)
        }
        _tableView?.reloadData()
        self._refreshView()
    }
    func _setIconImg(__pic:NSDictionary){
        _profile_icon_img?._setPic(__pic,__block: { (__dict) -> Void in
        })
    }
    
    func _getListHander(__list:NSArray){
        
    }
    
    //--------类型判断并设定
    func _checkType(){
        switch _type{
            case "friends":
                _title_label?.text = "朋友"
            break
        case "likes":
               _title_label?.text = "妙人"
            break
        default:
            break
        }
    }
    //----------------刷新布局
    func _refreshView(){
        
        if _hasNewMessage{
            _messageImg?.hidden=false
        }else{
            _messageImg?.hidden=true
        }
        _tableView?.frame = CGRect(x: 0, y: _profileH, width:  _myFrame!.width, height: _tableView!.contentSize.height)
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
        let _user:NSDictionary = _dict.objectForKey("author") as! NSDictionary
        let _pics:NSArray = _dict.objectForKey("ids") as! NSArray
        
        
        print("pics:sssdf",_pics)
        
        
        let _comments:NSArray = _dict.objectForKey("comments") as! NSArray
        let likes:NSArray = _dict.objectForKey("likes") as! NSArray
        //print(_dict)
        
        
        
        var cell:PicAlbumMessageItem?
        //cell = tableView.viewWithTag(100+indexPath.row) as? PicAlbumMessageItem
        cell = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as? PicAlbumMessageItem
        cell?._type = "status"
        cell!.setup(CGSize(width: self.view.frame.width, height: _heighArray?.objectAtIndex(indexPath.row) as! CGFloat))
        
        
        cell!.separatorInset = UIEdgeInsetsZero
        cell!.preservesSuperviewLayoutMargins = false
        cell!.layoutMargins = UIEdgeInsetsZero
        
        //cell!.tag = 100+indexPath.row
        //let _array:NSArray = _commentsArray?.objectAtIndex(indexPath.row) as! NSArray
        //cell!._setComments(_array, __allNum: _array.count)
        //let _likeA:NSArray = _likeArray?.objectAtIndex(indexPath.row) as! NSArray
        //cell!._setLikes(_likeA,__allNum: _likeA.count)
        cell!._userId = _user.objectForKey("_id") as? String
        cell!._setUserImge(MainInterface._userAvatar(_user))
        cell!._setUserName(_user.objectForKey("nickname") as! String)
        cell!._indexId = indexPath.row
        cell!._delegate=self
        //cell!._setPic((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("cover") as! NSDictionary)
        //cell?._setPic(<#T##__pic: NSDictionary##NSDictionary#>)
        
        
        if _pics.count > 0{
            if let _cover:NSDictionary = _pics.objectAtIndex(0) as? NSDictionary{
                //print("封面：",_cover,"====")
                
                let _pic:NSDictionary = NSDictionary(objects: [MainInterface._imageUrl(_cover.objectForKey("thumbnail") as! String),"file"], forKeys: ["url","type"])
                
                cell!._setPic(_pic)
            }else{
               
                //cell!._setDescription("")
            }
            print("图片错误：",_dict)
        }
        
        cell!._setUpdateTime(CoreAction._dateDiff(_dict.objectForKey("create_at") as! String))
        
        
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
        
        
        //_contr._userId = __userId
        
        _contr._userId = "5695f072109391cc5fcb553d"
        
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
        _alerter?._setMenus(["举报"])
        _alerter?._show()
    }
    
    //------弹出框代理
    func _myAlerterClickAtMenuId(__id:Int){
        switch __id{
        case 0:
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
            let _setting:MySettings = MySettings()
            _setting._setDict(_userInfo!)
            self.navigationController?.pushViewController(_setting, animated: true)
            
        default:
            print("")
        }
    }
    
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        //setup(<#__frame: CGRect#>)
        
        
        //_setSign(_userInfo!.objectForKey("sign") as! String)
        //_setIconImg(_userInfo!.objectForKey("profileImg") as! NSDictionary)
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

