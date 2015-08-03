//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol Setting_rangeDelegate:NSObjectProtocol{
    func canceld()
    func saved(dict:NSDictionary)
}

class Setting_range: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    var _title_label:UILabel?
    var _delegate:Setting_rangeDelegate?
    
    var _tableView:UITableView?
    let _tableCellH:CGFloat=40
    var _settings:NSArray=[["title":"按创建时间倒序排列","des":""],["title":"按创建时间顺序排列","des":""]]
    
    var _selectedId:Int=0
    
    override func viewDidLoad() {
        setup()
        refreshView()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-50, y: 5, width: 40, height: 62))
        _btn_save?.setTitle("完成", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1), forState: UIControlState.Normal)
        _btn_save?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 5, width: self.view.frame.width-100, height: 62))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="图片显示顺序"
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "table_cell")
        _tableView?.scrollEnabled=false
        
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        _topBar?.addSubview(_title_label!)
        
        self.view.addSubview(_tableView!)
        
        _setuped=true
    }
    
    //设置栏代理
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        var cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "table_cell")
        
        //cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        
        var _img:UIImage?
        if indexPath.row==_selectedId{
            _img=UIImage(named: "icon_choose")!
        }else{
            _img=UIImage(named: "icon_unchoose")!
        }
        let itemSize:CGSize = CGSizeMake(25, 25);
        UIGraphicsBeginImageContext(itemSize);
        let imageRect:CGRect = CGRectMake(0, 0, 25, 25)
        _img!.drawInRect(imageRect)
        cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        cell.textLabel?.text=_settings.objectAtIndex(indexPath.row).objectForKey("title") as? String
        cell.detailTextLabel?.text=_settings.objectAtIndex(indexPath.row).objectForKey("des") as? String
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return _tableCellH
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _selectedId=indexPath.row
        _tableView?.reloadData()
    }
    
    //----设置位置
    func refreshView(){
        _tableView?.frame = CGRect(x: 0, y: 62+_gap, width: self.view.frame.width, height: 2*_tableCellH-1)
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
            _delegate?.canceld()
        case _btn_save!:
            var _dict:NSMutableDictionary=NSMutableDictionary()
            _dict.setObject("range", forKey: "Action_Type")
            _dict.setObject(_selectedId, forKey: "selectedId")
            _delegate?.saved(_dict)
            self.navigationController?.popViewControllerAnimated(true)
        default:
            println(sender)
        }
        
    }
}

