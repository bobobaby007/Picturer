//
//  AddressList_List.swift
//  Picturer
//
//  Created by Bob Huang on 16/2/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation

class NewsList:UIViewController, UITableViewDelegate,UITableViewDataSource{
    let _barH:CGFloat = 64
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _tableView:UITableView?
    let _tableCellH:CGFloat=40
    var _dataArray:NSArray = []
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.clearColor()
        self.automaticallyAdjustsScrollViewInsets = false
        _tableView=UITableView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.registerClass(NewsListCell.self, forCellReuseIdentifier: "NewsListCell")
        //_tableView?.scrollEnabled=false
        _tableView?.separatorColor = Config._color_social_gray_line
        _tableView?.separatorInset = UIEdgeInsets(top: 0, left: -200, bottom: 200, right: 200)
        
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        self.view.addSubview(_tableView!)
        _getData()
        _setuped=true
    }
    
    func _getData(){
       
    }
    func _setArray(__array:NSArray){
        _dataArray = __array
        // print("载入：",_tableView)
        if _tableView != nil{
            _tableView?.reloadData()
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        let cell:NewsListCell = _tableView!.dequeueReusableCellWithIdentifier("NewsListCell", forIndexPath: indexPath) as! NewsListCell
        //if cell.respondsToSelector("setSeparatorInset:") {
        //cell.separatorInset = UIEdgeInsetsZero
        //}
        //if cell.respondsToSelector("setLayoutMargins:") {
        //cell.layoutMargins = UIEdgeInsetsZero
        //}
        //if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
        //cell.preservesSuperviewLayoutMargins = false
        //}
        
        if let _dict = _dataArray.objectAtIndex(indexPath.row) as? NSDictionary{
            let _user:NSDictionary = _dict.objectForKey("follow") as! NSDictionary
            cell._setPic(MainInterface._userAvatar(_user))
            cell._setTitle(_user.objectForKey("nickname") as! String)
            cell._setDes("xiaobai_0434")
        }        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let _dict = _dataArray.objectAtIndex(indexPath.row) as? NSDictionary{
            let _user:NSDictionary = _dict.objectForKey("follow") as! NSDictionary
            _viewUser(_user.objectForKey("_id") as! String)
        }
        
        //cell.selected = false
        
        
    }
    func _viewUser(__userId: String) {
        let _controller:MyHomepage = MyHomepage()
        _controller._userId = __userId
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
}
