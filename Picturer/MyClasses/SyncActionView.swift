//
//  MyHomepage.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/29.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class SyncActionView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var _barH:CGFloat = 64
    var _title_label:UILabel?
    var _gap:CGFloat = 15
    
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_moreAction:UIButton?
    
    var _tableView:UITableView?
    
    var _actionsArray:NSArray=[]
    var _setuped:Bool = false
    
    var _scrollView:UIScrollView?
    
    
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
        
        
        _btn_moreAction=UIButton(frame:CGRect(x: self.view.frame.width-50, y: _barH-44, width: 50, height: 44))
        _btn_moreAction?.setImage(UIImage(named: "edit.png"), forState: UIControlState.Normal)
        _btn_moreAction?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = Config._font_topbarTitle
        _title_label?.text = "同步"
        
        _topBar?.addSubview(_title_label!)
        //_topBar?.addSubview(_btn_moreAction!)
        //----
        
        _tableView=UITableView()
        
        _tableView?.backgroundColor=UIColor.whiteColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: _barH+10, width: self.view.frame.width, height: self.view.frame.height-_barH-10)
        _tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CollectItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        _scrollView = UIScrollView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH))
        
        
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        _scrollView!.addSubview(_tableView!)
        //_scrollView?.scrollEnabled=true
        
        self.view.addSubview(_scrollView!)
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        
        
        _refreshDatas()
        //
        
        //
        //
        _setuped=true
    }
    
    
    
    //----更新数据
    
    func _refreshDatas(){
        _actionsArray = SyncAction._actions
        //print(_actionsArray)
        _tableView?.reloadData()
    }
    //----table 代理
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _actionsArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        //cell = tableView.viewWithTag(100+indexPath.row) as? CollectItem
        
        
        if let _cell = tableView.dequeueReusableCellWithIdentifier("CollectItem")  {
            cell = _cell
            //return cell
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CollectItem")
        }
        
        var _str:String = String(indexPath.row)
        
        let _dict:NSDictionary = _actionsArray.objectAtIndex(indexPath.row) as! NSDictionary
        
        _str = _str + (_dict.objectForKey("type") as! String)
        
        cell.textLabel?.text = _str
        
        
        return cell
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
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

