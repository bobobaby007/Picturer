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
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    var _dataArray:NSArray=["",""]
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AlbumListCell") as! AlbumListCell
        
        return cell
        
    }
    
    
    
    override func viewDidLoad() {
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        
        _topBar?.backgroundColor=UIColor.blackColor()
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 0, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: 62, width: self.view.frame.width, height: self.view.frame.height-62)
        _tableView?.registerClass(AlbumListCell.self, forCellReuseIdentifier: "AlbumListCell")
        
        self.view.addSubview(_tableView!)
        
        self.view.addSubview(_topBar!)
        _topBar?.addSubview(_btn_cancel!)
        
        
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
    
    func clickAction(sender:UIButton){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

