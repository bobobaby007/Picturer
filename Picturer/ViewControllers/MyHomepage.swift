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
    
    var _userId:String = "000001"
    
    
    var _frameW:CGFloat?
    var _gap:CGFloat?
    var _gapY:CGFloat?
    var _imgW:CGFloat?
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    var _dataArray:NSArray=["http://pic.miercn.com/uploads/allimg/150721/40-150H10U219.jpg","http://e.hiphotos.baidu.com/image/pic/item/42166d224f4a20a4aac7452992529822730ed007.jpg","http://g.hiphotos.baidu.com/image/pic/item/caef76094b36acafd0c0d5fd7ed98d1001e99c8b.jpg","http://b.hiphotos.baidu.com/image/pic/item/d6ca7bcb0a46f21f779e1349f5246b600c33ae06.jpg","http://c.hiphotos.baidu.com/image/pic/item/0dd7912397dda144476ed9afb0b7d0a20cf4864c.jpg","http://pic.miercn.com/uploads/allimg/150721/40-150H10U219.jpg","http://e.hiphotos.baidu.com/image/pic/item/42166d224f4a20a4aac7452992529822730ed007.jpg","http://g.hiphotos.baidu.com/image/pic/item/caef76094b36acafd0c0d5fd7ed98d1001e99c8b.jpg","http://b.hiphotos.baidu.com/image/pic/item/d6ca7bcb0a46f21f779e1349f5246b600c33ae06.jpg","http://c.hiphotos.baidu.com/image/pic/item/0dd7912397dda144476ed9afb0b7d0a20cf4864c.jpg"]
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
    
    var _label_followed:UILabel?
     var _label_following:UILabel?
     var _label_album:UILabel?
    
    var _profileH:CGFloat = 130
    
    var _scrollView:UIScrollView?
    
    var _heighArray:NSMutableArray?
    var _commentsArray:NSMutableArray?
    
    
    
    var _defaultH:CGFloat = 400
    
    var _scrollTopH:CGFloat = 30 //达到这个高度时向上移动
    
    
    func setup(){
        if _setuped {
            return
        }
        
        _frameW = self.view.frame.width
        _gap = 0.04*_frameW!
        _gapY = 0.06*_frameW!
        _imgW = 0.22*_frameW!
        _profileH = _imgW! + 2*_gapY!
        
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        
        _topBar?.backgroundColor=UIColor.blackColor()
        
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 30, height: 62))
        _btn_cancel?.setTitle("<", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _profilePanel = UIView(frame: CGRect(x: 0, y: 62, width: self.view.frame.width, height: _profileH))
        _profilePanel?.backgroundColor = UIColor.whiteColor()
        
        
        _profile_icon_img = PicView(frame: CGRect(x: _gap!, y: _gapY!, width: _imgW!, height: _imgW!))
        _profile_icon_img?.scrollEnabled=false
        _profile_icon_img?.minimumZoomScale=1
        _profile_icon_img?.maximumZoomScale=1
        _profile_icon_img?._imgView?.contentMode=UIViewContentMode.ScaleAspectFill
        _profile_icon_img?._imgView?.layer.masksToBounds=true
        _profile_icon_img?._imgView?.layer.cornerRadius = 0.5*_profile_icon_img!.frame.width
        
        _btn_edite = UIButton(frame: CGRect(x: 0.275*_frameW!,y: _gapY!+0.6*_imgW!,width: 2*0.33*(_frameW!-_gap!-0.275*_frameW!),height: 0.4*_imgW!))
        _btn_edite?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_edite?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        _btn_edite?.layer.masksToBounds = true
        _btn_edite?.layer.cornerRadius = 5
        _btn_edite?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_edite?.setTitle("编辑个人主页", forState: UIControlState.Normal)
        _btn_edite?.titleLabel?.font=UIFont.systemFontOfSize(15)
        _btn_edite?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_share = UIButton(frame: CGRect(x: _btn_edite!.frame.origin.x+_btn_edite!.frame.width+3,y: _btn_edite!.frame.origin.y,width: _frameW!-_btn_edite!.frame.origin.x-_btn_edite!.frame.width-3-_gap!,height: _btn_edite!.frame.height))
        _btn_share?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_share?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        _btn_share?.layer.masksToBounds = true
        _btn_share?.layer.cornerRadius = 5
        _btn_share?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_share?.setTitle("分享", forState: UIControlState.Normal)
        _btn_share?.titleLabel?.font=UIFont.systemFontOfSize(15)
        _btn_share?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_follow = UIButton(frame: _btn_edite!.frame)
        _btn_follow?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_follow?.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _btn_follow?.layer.masksToBounds = true
        _btn_follow?.layer.cornerRadius = 5
        _btn_follow?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_follow?.setTitle("+关注", forState: UIControlState.Normal)
        _btn_follow?.titleLabel?.font=UIFont.systemFontOfSize(15)
        _btn_follow?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_message = UIButton(frame: _btn_share!.frame)
        _btn_message?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_message?.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _btn_message?.layer.masksToBounds = true
        _btn_message?.layer.cornerRadius = 5
        _btn_message?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_message?.setTitle("私信", forState: UIControlState.Normal)
        _btn_message?.titleLabel?.font=UIFont.systemFontOfSize(15)
        _btn_message?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        
        _label_album = UILabel(frame: CGRect(x: _btn_edite!.frame.origin.x,y: 0.26*_imgW!+_gapY!,width: 0.5*_btn_edite!.frame.width,height: 15))
        _label_album?.textColor = UIColor.darkGrayColor()
        _label_album?.textAlignment = NSTextAlignment.Center
        _label_album?.text = "图册"
        _label_album?.font=UIFont.systemFontOfSize(15)
        
        
        _label_followed = UILabel(frame: CGRect(x: _btn_edite!.frame.origin.x+0.5*_btn_edite!.frame.width,y: _label_album!.frame.origin.y,width: 0.5*_btn_edite!.frame.width,height: 15))
        _label_followed?.textColor = UIColor.darkGrayColor()
        _label_followed?.textAlignment = NSTextAlignment.Center
        _label_followed?.text="被关注"
        _label_followed?.font=UIFont.systemFontOfSize(15)
        
        _label_following = UILabel(frame: CGRect(x: _btn_share!.frame.origin.x,y: _label_album!.frame.origin.y,width: _btn_share!.frame.width,height: 15))
        _label_following?.textColor = UIColor.darkGrayColor()
        _label_following?.textAlignment = NSTextAlignment.Center
        _label_following?.text="关注"
        _label_following?.font=UIFont.systemFontOfSize(15)
        
        
        _albumNum_label = UILabel(frame:CGRect(x:_label_album!.frame.origin.x,y:_gapY!,width:_label_album!.frame.width,height:20))
       
        _albumNum_label?.textColor = UIColor.blackColor()
        _albumNum_label?.textAlignment = NSTextAlignment.Center
        _albumNum_label?.text = "0"
        
        
        
        _followed_label = UILabel(frame: CGRect(x: _albumNum_label!.frame.origin.x+_albumNum_label!.frame.width,y: _albumNum_label!.frame.origin.y,width: _albumNum_label!.frame.width,height: _albumNum_label!.frame.height))
        _followed_label?.textColor = UIColor.blackColor()
        _followed_label?.textAlignment = NSTextAlignment.Center
        _followed_label?.text="0"
        
        
        _following_label = UILabel(frame: CGRect(x: _btn_share!.frame.origin.x,y: _albumNum_label!.frame.origin.y,width: _btn_share!.frame.width,height: _albumNum_label!.frame.height))
        _following_label?.textColor = UIColor.blackColor()
        _following_label?.textAlignment = NSTextAlignment.Center
        _following_label?.text="0"
        
        
        
        
        _heighArray=NSMutableArray()
        
        _commentsArray=NSMutableArray()
        
        for var i:Int=0; i<_dataArray.count;++i{
            _heighArray?.addObject(_defaultH)
            
            
            MainAction._getCommentsOfAlubm(String(i), block: { (array) -> Void in
                self._commentsArray?.addObject(array)
            })
            
            
        }
        
        
        
        
        _tableView=UITableView()
        
        _tableView?.backgroundColor=UIColor.whiteColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: 62+_profileH+10, width: self.view.frame.width, height: self.view.frame.height-62-_profileH-10)
        _tableView?.registerClass(PicAlbumMessageItem.self, forCellReuseIdentifier: "PicAlbumMessageItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        //_tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        //_scrollView = UIScrollView(frame: CGRect(x: 0, y: 62, width: self.view.frame.width, height: self.view.frame.height-62))
        
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 1)
        self.view!.addSubview(_tableView!)
        //self.view.addSubview(_scrollView!)

        self.view.addSubview(_topBar!)

        
        
        self.view.addSubview(_profilePanel!)
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

        _topBar?.addSubview(_btn_cancel!)
//
        _getDatas()
//
//        
        _setuped=true
    }
    
    func _getDatas(){
        MainAction._getUserProfileAtId(_userId, block: {(__dict) -> Void in
            self._getProfileHander(__dict)}
        )
    }

    
    func _getProfileHander(__dict:NSDictionary){
        _profileDict=__dict
        _refreshView()
    }
    func _getListHander(__list:NSArray){
        
    }
    
    func _refreshView(){
        if _userId == MainAction._userId{
            _btn_share?.hidden=false
            _btn_edite?.hidden=false
            _btn_follow?.hidden=true
            _btn_message?.hidden=true
        }else{
            _btn_share?.hidden=true
            _btn_edite?.hidden=true
            _btn_follow?.hidden=false
            _btn_message?.hidden=false
        }
        
        _profile_icon_img?._setPic(_profileDict?.objectForKey("profileImg") as! NSDictionary,__block: { (__dict) -> Void in
            
        })
        
       _profilePanel?.frame=CGRect(x: 0, y: 62, width: self.view.frame.width, height: _profileH)
        
        
    }
    
    //----table 代理
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
       // println(scrollView.contentOffset.y)
        var _offsetY:CGFloat = 0
        var _frameOff:CGFloat = 10
        if scrollView.contentOffset.y > _scrollTopH{
            _offsetY = scrollView.contentOffset.y-_scrollTopH
            UIApplication.sharedApplication().statusBarHidden=true
            
        }else{
            UIApplication.sharedApplication().statusBarHidden=false
        }
        if _offsetY>_profileH+62+_frameOff{
           _offsetY = _profileH+62+_frameOff
        }else{
            
        }
        
        if scrollView.contentOffset.y>0{
            _tableView?.frame = CGRect(x: 0, y: 62+_profileH-_offsetY+_frameOff, width: self.view.frame.width, height: self.view.frame.height-62-_profileH+_offsetY-_frameOff)
        }else{
            
        }
        _profilePanel?.frame=CGRect(x: 0, y: 62-_offsetY, width: self.view.frame.width, height: _profileH)
        
        _topBar?.frame=CGRect(x: 0, y:0-_offsetY, width: self.view.frame.width, height: 62)
        
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
        cell!.separatorInset = UIEdgeInsetsZero
        cell!.preservesSuperviewLayoutMargins = false
        cell!.layoutMargins = UIEdgeInsetsZero
        //cell!.tag = 100+indexPath.row
        let _array:NSArray = _commentsArray?.objectAtIndex(indexPath.row) as! NSArray
        cell!._setComments(_array, __allNum: _array.count)

        
        
        cell!._indexId = indexPath.row
        cell!._delegate=self
        cell!._setPic(NSDictionary(objects: [_dataArray.objectAtIndex(indexPath.row),"fromWeb"], forKeys: ["url","type"]))
        cell!._setUserImge(NSDictionary(objects: [_dataArray.objectAtIndex(indexPath.row),"fromWeb"], forKeys: ["url","type"]))
        cell!._setAlbumTitle("撒旦过呢个作品")
        
        
        
        cell!._setUpdateTime("下午 2:00 更新")
        cell!._setUserName("小小白")
        
        //cell!._refreshView()
        return cell!
        
    }
    
    
    //------相册代理
    
    func _resized(__indexId: Int, __height: CGFloat) {
        //println("changeH")
        
        var _lastH:CGFloat? = -10
        if _heighArray!.count>=__indexId+1{
         _lastH = CGFloat(_heighArray!.objectAtIndex(__indexId) as! NSNumber)
        }
        _heighArray![__indexId] = __height
        if _lastH != __height{
            _tableView?.reloadData()
        }
        
       // println(_heighArray)
        
    }
    func _moreComment(__indexId: Int) {
        println(__indexId)
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
    
    override func viewDidLoad() {
       setup()
        self.automaticallyAdjustsScrollViewInsets=false
       UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
    
    func clickAction(sender:UIButton){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

