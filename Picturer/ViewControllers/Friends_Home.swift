//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class Friends_Home: UIViewController, UITableViewDataSource, UITableViewDelegate, PicAlbumMessageItem_delegate{
    
    var _type:String = "friends" //friends,likes
    
    var _barH:CGFloat = 64
    var _myFrame:CGRect?
    
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
        _imgW = 0.22*_frameW!
        
        
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
        _title_label?.text = "朋友"
        
        
        _topBar?.addSubview(_title_label!)
        _topBar?.addSubview(_btn_moreAction!)
        
        
        
        
        
        
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
        _tableView?.registerClass(PicAlbumMessageItem.self, forCellReuseIdentifier: "PicAlbumMessageItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        //_tableView?.separatorColor=UIColor.clearColor()
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
        switch _type{
            case "friends":
                MainAction._getMessages { (array) -> Void in
                    self._messageIn(array)
                }
            break
            case "likes":
                MainAction._getMessages { (array) -> Void in
                    self._messageIn(array)
            }
        default:
            break
        }
        
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
        switch _type{
        case "friends":
            MainAction._getFriendsNewsList({ (array) -> Void in
                self._datasIn(array)
            })
            break
        case "likes":
            MainAction._getLikesNewsList({ (array) -> Void in
                self._datasIn(array)
            })
            
        default:
            break
        }
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
            MainAction._getCommentsOfAlubm(String(i), block: { (array) -> Void in
                self._commentsArray?.addObject(array)
            })
            MainAction._getLikesOfAlubm(String(i), block: { (array) -> Void in
                self._likeArray?.addObject(array)
            })
        }
        _tableView?.reloadData()
        
    }
    
    
    func _getListHander(__list:NSArray){
        
    }
    //----------------刷新布局
    func _refreshView(){
        UIView.beginAnimations("go", context: nil)
        if _hasNewMessage{
            _messageAlertView!.frame = CGRect(x: _myFrame!.width/2 - 194/2, y: 10, width: 194, height: 40)
            _messageAlertView?.hidden=false
            _messageH = 40+20
        }else{
            _messageAlertView?.hidden=true
            _messageH = 0
        }
        _tableView?.frame = CGRect(x: 0, y: _messageH, width:  _myFrame!.width, height: _tableView!.contentSize.height)
        
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
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:PicAlbumMessageItem?
        //cell = tableView.viewWithTag(100+indexPath.row) as? PicAlbumMessageItem
        
        
        cell = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as? PicAlbumMessageItem
        
        cell!._type = "pics"
        cell!._pics = (_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("pics") as? NSArray
        
        
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
        
        cell!._indexId = indexPath.row
        cell!._delegate=self
        
        
        
        cell!._userId = (_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("userId") as? String
    
        cell!._setUserImge((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("userImg") as! NSDictionary)
        cell!._setAlbumTitle((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("title") as! String)
        //cell!._setDescription((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("description") as! String)
        cell!._setUpdateTime("下午 2:00 更新")
        cell!._setUserName((_dataArray.objectAtIndex(indexPath.row) as? NSDictionary)?.objectForKey("userName") as! String)
        //cell!._refreshView()
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
        if _lastH != __height{
            
            _heighArray![__indexId] = __height
            _tableView?.reloadData()
            _refreshView()
        }
        
        // println(_heighArray)
    }
    func _viewAlbum(__albumIdex:Int) {
        
        
        MainAction._getPicsListAtAlbumId("00003", block: { (array) -> Void in
            var _controller:Social_pic = Social_pic()
            _controller._showIndexAtPics(0, __array: array)
            self.navigationController?.pushViewController(_controller, animated: true)
            
        })
    }
    func _viewPicsAtIndex(__array:NSArray,__index:Int){

        var _controller:Social_pic = Social_pic()
        
        var _pics:NSMutableArray = NSMutableArray()
        
        for i in 0...__array.count{
            _pics.addObject(NSDictionary(objects: [__array.objectAtIndex(i),3,5], forKeys: ["pic","likeNumber","commentNumber"]))
           
        }
        _controller._showIndexAtPics(__index, __array: _pics)
        self.navigationController?.pushViewController(_controller, animated: true)

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

