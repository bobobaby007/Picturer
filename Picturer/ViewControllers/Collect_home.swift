//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class Collect_home: UIViewController, UITableViewDataSource, UITableViewDelegate, CollectItem_delegate{
    
    
    var _barH:CGFloat = 64
    var _myFrame:CGRect?
    
    var _title_label:UILabel?
    var _frameW:CGFloat?
    var _gap:CGFloat = 15
    var _gapY:CGFloat?
    var _imgW:CGFloat?
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_moreAction:UIButton?
    
    var _tableView:UITableView?
    
    var _dataArray:NSArray=[]
    var _setuped:Bool = false
    
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
    weak var _naviDelegate:Navi_Delegate?
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets=false
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        
        setup(self.view.frame)
        
        ImageLoader.sharedLoader._removeAllTask()
        _getDatas()
    }
    func setup(__frame:CGRect){
        if _setuped {
            return
        }
        _myFrame = __frame
        _frameW = _myFrame!.width
        
        _gapY = 0.06*_frameW!
        _imgW = 0.22*_frameW!
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: _myFrame!.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_moreAction=UIButton(frame:CGRect(x: self.view.frame.width-50, y: _barH-44, width: 50, height: 44))
        _btn_moreAction?.setImage(UIImage(named: "edit.png"), forState: UIControlState.Normal)
        _btn_moreAction?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = Config._font_topbarTitle
        _title_label?.text = "收藏"
        
        _topBar?.addSubview(_title_label!)
        //_topBar?.addSubview(_btn_moreAction!)
        //---消息提醒----
        _messageAlertView = UIView(frame: CGRect(x: 0, y: 10, width: 194, height: 40))
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
        
        _tableView?.backgroundColor=UIColor.whiteColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: _barH+10, width: _myFrame!.width, height: _myFrame!.height-_barH-10)
        _tableView?.registerClass(CollectItem.self, forCellReuseIdentifier: "CollectItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        _scrollView = UIScrollView(frame: CGRect(x: 0, y: _barH, width: _myFrame!.width, height: _myFrame!.height-_barH))
        
        
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        _scrollView!.addSubview(_tableView!)
        //_scrollView?.scrollEnabled=true
        
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
//        MainAction._getMessages { (array) -> Void in
//            self._messageIn(array)
//        }
    }
    
    func _messageIn(array:NSArray){
        self._hasNewMessage = true
        self._messageArray = array
        
        self._messageImg!._setPic((array.objectAtIndex(0) as! NSDictionary).objectForKey("userImg") as! NSDictionary, __block: { (__dict) -> Void in
            
        })
        self._messageText!.text = String(array.count)+"条新消息"
        self._refreshView()
    }
    //----消息按钮侦听
    
    func messageTapHander(__sender:UITapGestureRecognizer){
        _hasNewMessage = false
        _refreshView()
        _openMessageList()
    }
    
    
    
    func _getDatas(){
        Social_Main._getCollectList({[weak self] (array) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?._datasIn(array)
            })
            
        })
    }
    func _datasIn(__array:NSArray){
        self._dataArray = __array
        self._refreshDatas()
        self._getMessage()
    }
    
    
    //----更新数据
    
    func _refreshDatas(){
        
        //-----初始化数据
        
        _heighArray=NSMutableArray()
        _commentsArray=NSMutableArray()
        _likeArray = NSMutableArray()
        for var i:Int=0; i<_dataArray.count;++i{
            _heighArray?.addObject(_defaultH)
//            Social_Main._getCommentsOfAlubm(String(i), block: { (array) -> Void in
//                self._commentsArray?.addObject(array)
//            })
//            Social_Main._getLikesOfAlubm(String(i), block: { (array) -> Void in
//                self._likeArray?.addObject(array)
//            })
        }
        _tableView?.reloadData()
        
    }
    
    
    func _getListHander(__list:NSArray){
        
    }
    //----------------刷新布局
    func _refreshView(){
        _tableView?.frame = CGRect(x: 0, y: _messageH, width:  _myFrame!.width, height: _tableView!.contentSize.height)
        _tableView?.scrollEnabled = false
        _scrollView?.contentSize = CGSize(width: _myFrame!.width, height: _tableView!.frame.origin.y+_tableView!.frame.height+_gap)
       
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
        
        //var cell:CollectItem? = tableView.viewWithTag(100+indexPath.row) as? CollectItem
        //var cell:CollectItem = tableView.dequeueReusableCellWithIdentifier("CollectItem") as! CollectItem
        // println(_heighArray?.count)
        if _heighArray!.count>=indexPath.row+1{
            return CGFloat(_heighArray!.objectAtIndex(indexPath.row) as! NSNumber)
        }
        //println(_heighArray.objectAtIndex(indexPath.row))
        return 425
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CollectItem?
        //cell = tableView.viewWithTag(100+indexPath.row) as? CollectItem
        let _com:NSDictionary = _dataArray.objectAtIndex(indexPath.row) as! NSDictionary
        let _album = _com.objectForKey("album") as! NSDictionary
        
        print("收藏相册单条信息：",_album)
        
        let _user:NSDictionary = _album.objectForKey("author") as! NSDictionary
        
        
        cell = tableView.dequeueReusableCellWithIdentifier("CollectItem") as? CollectItem
        
        cell!.setup(CGSize(width: self.view.frame.width, height: _defaultH))
        
        cell!.separatorInset = UIEdgeInsetsZero
        cell!.preservesSuperviewLayoutMargins = false
        cell!.layoutMargins = UIEdgeInsetsZero
        
        
        cell!._indexId = indexPath.row
        cell!._delegate=self
        
        
        cell!._userId = _user.objectForKey("_id") as? String
        cell!._setUserImge(MainInterface._userAvatar(_user))
        
        cell!._setDescription(_album.objectForKey("description") as! String)
        cell!._setUpdateTime(CoreAction._dateDiff(_com.objectForKey("create_at") as! String))
        cell!._setUserName(_user.objectForKey("nickname") as! String)
        
        
//        cell!._setAlbumTitle(_album.objectForKey("title") as! String,__num: 19)
//        if let _cover = _album.objectForKey("cover") as? NSDictionary{
//            cell!._setPic(_cover)
//        }else{
//            let _pic:NSDictionary = NSDictionary(objects: ["no_cover","file"], forKeys: ["url","type"])
//            cell!._setPic(_pic)
//        }
        
        cell?._album = _album
        cell?._getPics()
        
        cell!._refreshView()
        //cell!._refreshView()
        return cell!
    }
    //------相册单元代理
    func _resized(__indexId: Int, __height: CGFloat) {
        //println("changeH")
        
        var _lastH:CGFloat? = -10
        if _heighArray!.count>=__indexId+1{
            _lastH = CGFloat(_heighArray!.objectAtIndex(__indexId) as! NSNumber)
        }else{
            _heighArray?.addObject(__height)
        }
        if _lastH != __height{
            //println(String(__indexId)+":"+String(stringInterpolationSegment: __height))
            _heighArray![__indexId] = __height
            _tableView?.reloadData()
            _refreshView()
        }
        
        // println(_heighArray)
    }
    func _viewAlbum(__albumIdex:Int) {
        
        let _com = _dataArray.objectAtIndex(__albumIdex) as! NSDictionary
        let _album = _com.objectForKey("album") as! NSDictionary
        
        Social_Main._getPicsListAtAlbumId(_album.objectForKey("_id") as? String, __block: { [weak self] (array) -> Void in
            if array.count<=0{
                print("没有图片")
                return
            }
            print("获取图片成功",array)
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
    func _moreComment(__indexId: Int) {
        let _controller:CommentList = CommentList()
        //println(__dict)
        
        _controller._dealWidthDatas(_commentsArray!.objectAtIndex(__indexId) as! NSArray)
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
            let _cell:CollectItem = _tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: __dict.objectForKey("indexId") as! Int, inSection: 0)) as! CollectItem
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
            _controller._dealWidthDatas(_commentsArray!.objectAtIndex(_cell._indexId) as! NSArray)
            
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
        print(__dict.objectForKey("text"))
        _inputer?._close()
    }
    func _inputer_changed(__dict: NSDictionary) {
        print(__dict.objectForKey("text"))
    }
    //-------------
    
    func btnHander(sender:UIButton){
        switch sender{
            
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
        case _btn_moreAction!:
            let _alertController:UIAlertController = UIAlertController()
            
            let _action:UIAlertAction = UIAlertAction(title: "消息列表", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self._hasNewMessage = false
                self._refreshView()
                self._openMessageList()
            })
            
            let _actionCancel:UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
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
        
        let _controller:MessageList = MessageList()
        self.navigationController?.pushViewController(_controller, animated: true)
    }
    
    
}

