//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Discover_reference: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    let _barH:CGFloat = 64
    //var _topBar:UIView?
    //var _btn_cancel:UIButton?
    var _setuped:Bool=false
    
    var _searchBarH:CGFloat = 43
    var _searchBar:UIView = UIView()
    var _searchT:UITextField = UITextField()
    var _gap:CGFloat = 10
    
    var _referenceTable:UITableView = UITableView()
    
    var _referenceArray:NSArray = NSArray()
    var _recentArray:NSArray = NSArray()
    
    var _searchResult:SearchResult?
    
    var _searchingStr:String = ""
    
    
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
//        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
//        _topBar?.backgroundColor=UIColor.blackColor()
//        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: _barH))
//        _btn_cancel?.setTitle("返回", forState: UIControlState.Normal)
//        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        _topBar?.addSubview(_btn_cancel!)

        
        
        
       _searchBar.frame = CGRect(x: 0, y: _barH, width: self.view.frame.width, height: _searchBarH)
        _searchBar.backgroundColor = UIColor(red: 201/255, green: 201/255, blue: 206/255, alpha: 1)
        var _searchLableV:UIView = UIView(frame: CGRect(x: _gap, y: 7, width: self.view.frame.width-2*_gap, height: _searchBarH-14))
        _searchLableV.backgroundColor = UIColor.whiteColor()
        _searchLableV.layer.cornerRadius=5
        
        var _icon:UIImageView = UIImageView(image: UIImage(named: "search_icon.png"))
        _icon.frame=CGRect(x: _gap, y: 10, width: 13, height: 13)
        
        _searchT.frame = CGRect(x: _gap+13+5, y: 1, width: self.view.frame.width-2*_gap-_gap, height: _searchBarH-14)
        _searchT.placeholder = "搜索"
        _searchT.font = UIFont.systemFontOfSize(13)
        _searchT.delegate = self
        _searchT.returnKeyType = UIReturnKeyType.Search
        
        
        _searchLableV.addSubview(_icon)
        _searchLableV.addSubview(_searchT)
        _searchBar.addSubview(_searchLableV)
        
        
        
        _searchResult = SearchResult(frame: CGRect(x: 0, y: _barH+_searchBarH, width: self.view.frame.width, height: self.view.frame.height-_barH-_searchBarH))
        
        
        self.view.addSubview(_searchBar)
        //self.view.addSubview(_topBar!)
        
        _referenceTable.frame = CGRect(x: 0, y: _barH+_searchBarH, width: self.view.frame.width, height: self.view.frame.height-_barH-_searchBarH)
        _referenceTable.delegate=self
        _referenceTable.dataSource = self
        _referenceTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "table_cell")
       
        _searchResult = SearchResult(frame: CGRect(x: 0, y: _barH+_searchBarH, width: self.view.frame.width, height: self.view.frame.height-_barH-_searchBarH))
        
        //_showSearchReference()
        _showSearchResult()
        
        _getDatas()
        
        _setuped=true
    }
    func _showSearchReference(){
        _searchResult!.removeFromSuperview()
        self.view.addSubview(_referenceTable)
    }
    func _showSearchResult(__str:String){
        
        
        
        _referenceTable.removeFromSuperview()
        self.view.addSubview(_searchResult!)
    }
    
    
    
    
    func _getDatas(){
        _recentArray = MainAction._getRecentSearchTags()
        MainAction._getReferenceTags { (array) -> Void in
            self._referenceArray = array
            self._referenceTable.reloadData()
        }
    }
    
    //---
    func textFieldDidBeginEditing(textField: UITextField) {
        _showSearchReference()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        println(_searchT.text)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    //--
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var _view:UIView = UIView()
        var _label:UILabel = UILabel(frame: CGRect(x: _gap, y: 0, width: self.view.frame.width-2*_gap, height: 30))
        _label.font =  UIFont.systemFontOfSize(12)
        switch section{
        case 0:
            _label.text="最近搜索标签"
            break
        case 1:
            _label.text="热门标签"
            
            break
        default:
            _label.text="热门标签"
            break
        }
        _view.addSubview(_label)
        
        _view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        return _view
        
    }
//    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//        return ["sdg","sdg","sdg","sdg","sdg","sdg","sdg","sdg","sdg"]
//    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "标题"
//    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
           return _recentArray.count
        case 1:
           return _referenceArray.count
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "table_cell")
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        //cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        
        switch indexPath.section{
        case 0:
            cell.textLabel?.text=(_recentArray.objectAtIndex(indexPath.row) as! String)
        case 1:
            cell.textLabel?.text=(_referenceArray.objectAtIndex(indexPath.row) as! String)
        default:
            break
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            
            break
        case 1:
           
            break
        default:
            
            break
        }
    }
    func clickAction(sender:UIButton){
        switch sender{
        
        default:
            return
        }
        
    }
}

