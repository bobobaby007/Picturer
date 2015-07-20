//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class MyHomepage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var _userId:String = "000000"
    
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    var _dataArray:NSArray=["",""]
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
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PicAlbumMessageItem") as! PicAlbumMessageItem
        
        return cell
        
    }
    
    func setup(){
        if _setuped {
            return
        }
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        
        _topBar?.backgroundColor=UIColor.blackColor()
        
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 100, height: 62))
        _btn_cancel?.setTitle("<", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _profilePanel = UIView(frame: CGRect(x: 0, y: 62, width: self.view.frame.width, height: _profileH))
        _profilePanel?.backgroundColor = UIColor.whiteColor()
        
        
        _profile_icon_img = PicView(frame: CGRect(x: 15, y: 15, width: 90, height: 90))
        _profile_icon_img?.scrollEnabled=false
        _profile_icon_img?._imgView?.contentMode=UIViewContentMode.ScaleAspectFill
        _profile_icon_img?._imgView?.layer.masksToBounds=true
        _profile_icon_img?._imgView?.layer.cornerRadius = 45
        
        _btn_edite = UIButton(frame: CGRect(x: 115,y: 70,width: 160,height: 35))
        _btn_edite?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_edite?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        _btn_edite?.layer.masksToBounds = true
        _btn_edite?.layer.cornerRadius = 5
        _btn_edite?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_edite?.setTitle("编辑个人主页", forState: UIControlState.Normal)
        _btn_edite?.titleLabel?.font=UIFont.systemFontOfSize(15)
        
        _btn_share = UIButton(frame: CGRect(x: 280,y: 70,width: 90,height: 35))
        _btn_share?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_share?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        _btn_share?.layer.masksToBounds = true
        _btn_share?.layer.cornerRadius = 5
        _btn_share?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_share?.setTitle("分享", forState: UIControlState.Normal)
        _btn_share?.titleLabel?.font=UIFont.systemFontOfSize(15)
        
        _btn_follow = UIButton(frame: CGRect(x: 115,y: 70,width: 160,height: 35))
        _btn_follow?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_follow?.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _btn_follow?.layer.masksToBounds = true
        _btn_follow?.layer.cornerRadius = 5
        _btn_follow?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_follow?.setTitle("+关注", forState: UIControlState.Normal)
        _btn_follow?.titleLabel?.font=UIFont.systemFontOfSize(15)
        
        
        _btn_message = UIButton(frame: CGRect(x: 280,y: 70,width: 90,height: 35))
        _btn_message?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_message?.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _btn_message?.layer.masksToBounds = true
        _btn_message?.layer.cornerRadius = 5
        _btn_message?.titleLabel?.textAlignment = NSTextAlignment.Center
        _btn_message?.setTitle("私信", forState: UIControlState.Normal)
        _btn_message?.titleLabel?.font=UIFont.systemFontOfSize(15)
        
        
        _label_album = UILabel(frame: CGRect(x: 120,y: 33,width: 100,height: 35))
        _label_album?.textColor = UIColor.darkGrayColor()
        _label_album?.textAlignment = NSTextAlignment.Center
        _label_album?.text = "图册"
        _label_album?.font=UIFont.systemFontOfSize(15)
        
        
        _label_followed = UILabel(frame: CGRect(x: 200,y: 33,width: 100,height: 35))
        _label_followed?.textColor = UIColor.darkGrayColor()
        _label_followed?.textAlignment = NSTextAlignment.Center
        _label_followed?.text="被关注"
        _label_followed?.font=UIFont.systemFontOfSize(15)
        
        _label_following = UILabel(frame: CGRect(x: 300,y: 33,width: 50,height: 35))
        _label_following?.textColor = UIColor.darkGrayColor()
        _label_following?.textAlignment = NSTextAlignment.Center
        _label_following?.text="关注"
        _label_following?.font=UIFont.systemFontOfSize(15)
        
        
        _albumNum_label = UILabel(frame: CGRect(x: 120,y: 10,width: 100,height: 35))
        _albumNum_label?.textColor = UIColor.blackColor()
        _albumNum_label?.textAlignment = NSTextAlignment.Center
        _albumNum_label?.text = "0"
        
        
        
        _followed_label = UILabel(frame: CGRect(x: 200,y: 10,width: 100,height: 35))
        _followed_label?.textColor = UIColor.blackColor()
        _followed_label?.textAlignment = NSTextAlignment.Center
        _followed_label?.text="0"
        
        
        _following_label = UILabel(frame: CGRect(x: 300,y: 10,width: 50,height: 35))
        _following_label?.textColor = UIColor.blackColor()
        _following_label?.textAlignment = NSTextAlignment.Center
        _following_label?.text="0"
        
        
//        
//        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: 62+_profileH+10, width: self.view.frame.width, height: self.view.frame.height-62)
        _tableView?.registerClass(PicAlbumMessageItem.self, forCellReuseIdentifier: "PicAlbumMessageItem")
        
        
        
        
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 1)
        self.view.addSubview(_tableView!)
//
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
        
        _profile_icon_img?._setPic(_profileDict?.objectForKey("profileImg") as! NSDictionary)
       _profilePanel?.frame=CGRect(x: 0, y: 62, width: self.view.frame.width, height: _profileH)
        
        
    }
    
    override func viewDidLoad() {
       setup()
        
        
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
    
    func clickAction(sender:UIButton){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

