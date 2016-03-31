//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class AlbumDetail: UIViewController, UITableViewDataSource, UITableViewDelegate, PicAlbumMessageItem_delegate,MyAlerter_delegate{
    var _album:NSDictionary?
    var _albumId:String?
    var _user:NSDictionary?
    var _pics:NSArray? = []
    var _comments:NSArray = []
    var _likes:NSArray = []
    
    var _barH:CGFloat = 64
    var _title_label:UILabel?
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    
    var _setuped:Bool = false
    var _alerter:MyAlerter?
    
    var _currentEditeIndex:Int? = 0
    
    
    
    var _defaultH:CGFloat = 632
    
    
    var _inputer:Inputer?
    
    
    weak var _naviDelegate:Navi_Delegate?
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets=false
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        
        setup()
       
    }
    
    func setup(){
        if _setuped {
            return
        }
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = Config._font_topbarTitle
        _title_label?.text = "详情页面"
        
        _topBar?.addSubview(_title_label!)
       
        
        
        //----
        
        _tableView=UITableView()
        
        _tableView?.backgroundColor=UIColor.clearColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH)
        _tableView?.registerClass(PicAlbumMessageItem.self, forCellReuseIdentifier: "PicAlbumMessageItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        //_tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        
        
        self.view.backgroundColor = Config._color_social_gray_light
        
        self.view.addSubview(_tableView!)
        //_scrollView?.scrollEnabled=true
        self.view.addSubview(_topBar!)
        
        //-----评论输入框
        _inputer = Inputer(frame: self.view.frame)
        _inputer?.setup()
        // _inputer?.hidden=true
        
        _topBar?.addSubview(_btn_cancel!)
        //
        //
        //
        
        _setuped=true
    }
    //---获取相册详情
    func _getAlbumDetail() -> Void {
        if _album != nil{
            self._getUserInfo()
        }
        return
        Social_Main._getAlbumDetail(_album!.objectForKey("_id") as? String) { (__dict) -> Void in
            self._album = __dict
            self._getUserInfo()
        }
    }
    
    
    //---获取用户信息
    func _getUserInfo() -> Void {
        if _user != nil{
            
            self._getPics()
            return
        }
        Social_Main._getUserProfileAtId(_album!.objectForKey("author") as! String) { (__dict) in
            self._user = __dict
            
            self._getPics()
        }
    }
    
    func _getDatas(){
        _getAlbumDetail()
    }
    
    func _getPics(){
        Social_Main._getPicsListAtAlbumId(self._album!.objectForKey("_id") as? String, __block: {[weak self] (array) -> Void in
            self?._pics = array
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?._refreshDatas()
                self?._getComments()
            })
        })

    }
    func _getComments() -> Void {
        Social_Main._getAlbumCommentAndLikes(self._album!.objectForKey("_id") as! String) { [weak self](__dict) in
            let _comments:NSArray = __dict.objectForKey("comment") as! NSArray
            let _likes:NSArray = __dict.objectForKey("like") as! NSArray
            self?._comments = _comments
            self?._likes = _likes
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?._refreshDatas()
            })
        }
    }
    
    
    //----更新数据
    func _refreshDatas(){
        
        _tableView?.reloadData()
    }
    
    //---table代理
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return _defaultH
    }
    
    //---------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //let _dict:NSDictionary = _dataArray.objectAtIndex(indexPath.row) as! NSDictionary
        //let _user:NSDictionary = _dict.objectForKey("author") as! NSDictionary
        //let _pics:NSArray = _dict.objectForKey("ids") as! NSArray
        
        
        //print("朋友的单条信息：",_dict)
        
       
        
        var cell:PicAlbumMessageItem?
        
        
        //cell = tableView.viewWithTag(100+indexPath.row) as? PicAlbumMessageItem
        cell = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as? PicAlbumMessageItem
       
        cell!.setup(CGSize(width: self.view.frame.width, height: _defaultH))
        
        
        cell!.separatorInset = UIEdgeInsetsZero
        cell!.preservesSuperviewLayoutMargins = false
        cell!.layoutMargins = UIEdgeInsetsZero
        
        //cell!.tag = 100+indexPath.row
        
        
        
        
        //cell?._setLiked(_hasLikedAtIndex(indexPath.row))
        
//        cell?._setCollected(_hasCollectdAtIndex(indexPath.row))
        
        cell!._userId = _user!.objectForKey("_id") as? String
        cell!._setUserImge(MainInterface._userAvatar(_user!))
        cell!._setUserName(_user!.objectForKey("nickname") as! String)
        cell!._indexId = indexPath.row
        cell!._delegate=self
        //cell!._setPic((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("cover") as! NSDictionary)
        //cell?._setPic(<#T##__pic: NSDictionary##NSDictionary#>)
        
        if let _cover:NSDictionary = _album?.objectForKey("cover") as? NSDictionary{
            //print("封面：",_cover,"====")
            let _pic:NSDictionary = NSDictionary(objects: [MainInterface._imageUrl(_cover.objectForKey("thumbnail") as! String),"file"], forKeys: ["url","type"])
            cell!._setPic(_pic)
        }else{
            if  _pics?.count > 0{
                cell!._setPic(_pics?.objectAtIndex(0) as! NSDictionary)
            }
            //cell!._setDescription("")
        }
        
        if let _title:String = _album!.objectForKey("title") as? String{
            cell!._setAlbumTitle(_title,__num: _pics!.count)
        }else{
            cell!._setAlbumTitle("",__num: _pics!.count)
        }
        if let _des:String = _album!.objectForKey("description") as? String{
            cell!._setDescription(_des)
        }else{
            cell!._setDescription("")
        }
        
        
        cell?._showAllComments = true
        
        cell!._setUpdateTime(CoreAction._dateDiff(_album!.objectForKey("create_at") as! String))
        
        cell!._setComments(_comments, __allNum: _comments.count)
        
        cell!._setLikeNum(self._likes.count)
        
        //cell!._refreshView()
        return cell!
    }
    
    //------相册单元代理
    func _resized(__indexId: Int, __height: CGFloat) {
       
        if _defaultH != __height{
            _defaultH = __height
            _tableView?.reloadData()
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
        
        Social_Main._getPicsListAtAlbumId(_album!.objectForKey("_id") as? String, __block: { (array) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let _controller:Social_pic = Social_pic()
                _controller._showIndexAtPics(0, __array: array)
                self.navigationController?.pushViewController(_controller, animated: true)
            })
        })
    }
    func _viewAlbumDetail(__albumIndex: Int) {
        
    }
    func _viewPicsAtIndex(__array: NSArray, __index: Int) {
        
    }
    func _moreComment(__indexId: Int) {
        
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
//            if _hasUserInLikesAtIndex(__dict.objectForKey("indexId") as! Int, __userId: Social_Main._currentUser.objectForKey("userId") as! String){
//                return
//            }
//            let _arr:NSMutableArray = NSMutableArray(array: self._likeArray!)
//            let _dict:NSMutableArray = NSMutableArray(array:_arr.objectAtIndex(__dict.objectForKey("indexId") as! Int) as! NSArray)
//            let _user:NSDictionary = Social_Main._currentUser as NSDictionary
//            _dict.addObject(NSDictionary(objects: [_user.objectForKey("userName") as! String,_user.objectForKey("userId") as! String], forKeys: ["userName","userId"]))
//            _arr[__dict.objectForKey("indexId") as! Int] = _dict
//            self._likeArray = _arr
//            Social_Main._postLike(NSDictionary())
//            
//            _tableView?.reloadData() //--------使用在线接口时全部请求信息后侦听里面再重新加载
            
            break
        case "comment":
            
            let _controller:CommentList = CommentList()
            _controller._type = CommentList._Type_album
            _controller._id = _album!.objectForKey("_id") as! String
            self.navigationController?.pushViewController(_controller, animated: true)
            
            break
        case "moreAction":
            _currentEditeIndex = __dict.objectForKey("indexId") as? Int
            _openMoreAction()
        case "moreLike":
            let _controller:LikeList = LikeList()
            //println(__dict)
            _controller._dataArray = NSMutableArray(array: _likes)
            self.navigationController?.pushViewController(_controller, animated: true)
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
        
        let _n:Int = _likes.count
        
        for var i:Int = 0 ; i<_n ;++i{
            if (_likes[i] as! NSDictionary).objectForKey("userId") as! String == __userId {
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
    
    
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        
    }
    override func viewDidAppear(animated: Bool) {
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
            break
        default:
            return
        }
    }
}

