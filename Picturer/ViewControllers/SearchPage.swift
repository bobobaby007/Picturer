//
//  SearchPage.swift
//  Picturer
//
//  Created by Bob Huang on 15/11/20.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


protocol SearchPage_delegate:NSObjectProtocol{
    func _searchPage_cancel()
}

class SearchPage: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,Manage_show_delegate,ShareAlert_delegate,Manage_newDelegate{
    let _barH:CGFloat = 64
    //var _topBar:UIView?
    //var _btn_cancel:UIButton?
    var _alerter:MyAlerter?
    var _shareAlert:ShareAlert?
    var _setuped:Bool=false
    let _statusH:CGFloat = 14
    let _searchBarH:CGFloat = 43
    var _searchBar:UIView = UIView()
    var _btn_cancel:UIButton?
    var _searchT:UITextField = UITextField()
    var _gap:CGFloat = 10
    
    var _currentIndex:NSIndexPath?
    var _tableView:UITableView?
    
    var _searchingStr:String = ""
    
    var _resultArray:NSArray = []
    var _blurV:UIVisualEffectView?
    
    weak var _delegate:SearchPage_delegate?
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        
        _blurV = UIVisualEffectView(frame: self.view.bounds)
        _blurV?.effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        
        self.view.addSubview(_blurV!)
        
        self.view.backgroundColor=UIColor(white: 1, alpha: 0.8)
        
        
        _searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: _searchBarH+_statusH)
        _searchBar.backgroundColor = MainAction._color_yellow
        let _searchLableV:UIView = UIView(frame: CGRect(x: _gap, y: 7+_statusH, width: self.view.frame.width-2*_gap-_gap-40, height: _searchBarH-14))
        _searchLableV.backgroundColor = UIColor.whiteColor()
        _searchLableV.layer.cornerRadius=5
        
        _btn_cancel = UIButton(frame: CGRect(x: _searchLableV.frame.origin.x+_searchLableV.frame.width+_gap, y: 7+_statusH, width: 40, height: _searchBarH-14))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let _icon:UIImageView = UIImageView(image: UIImage(named: "search_icon.png"))
        _icon.frame=CGRect(x: _gap, y: 10, width: 13, height: 13)
        
        _searchT.frame = CGRect(x: _gap+13+5, y: 1, width: self.view.frame.width-2*_gap-_gap, height: _searchBarH-14)
        _searchT.addTarget(self, action: "textDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        _searchT.placeholder = "搜索"
        _searchT.font = UIFont.systemFontOfSize(13)
        _searchT.delegate = self
        _searchT.returnKeyType = UIReturnKeyType.Search
        
        
        _searchLableV.addSubview(_icon)
        _searchLableV.addSubview(_searchT)
        _searchBar.addSubview(_searchLableV)
        _searchBar.addSubview(_btn_cancel!)
        
        _tableView = UITableView(frame: CGRect(x: 0, y: _searchBar.frame.height, width: self.view.frame.width, height: self.view.frame.height-_searchBar.frame.height))
        _tableView?.registerClass(AlbumListCell.self, forCellReuseIdentifier: "alum_cell")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.dataSource = self
        _tableView?.delegate = self
        _tableView!.tableFooterView=UIView(frame: CGRect(x: 0, y: 0, width: _tableView!.frame.width, height:10))
        _tableView!.backgroundColor = UIColor.clearColor()
        _tableView!.tableFooterView?.backgroundColor = UIColor.whiteColor()
        
        
        self.view.addSubview(_tableView!)
        self.view.addSubview(_searchBar)
       
        //_showSearchResult("")
        
        _setuped=true
    }
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            _delegate?._searchPage_cancel()
            break
        default:
            break
        }
    }
    
    
    func _search(){
        _resultArray = MainAction._searchAlbum(_searchT.text!)
        _tableView?.reloadData()
    }
    
    //---
    func textDidChanged(sender:UITextField){
        _search()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print(_searchT.text)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //_showSearchResult(textField.text!)
        
        return true
    }
    //---------tableview delegate
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return _tableView.bounds.size.height/5
        
        return 91
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let _album:NSDictionary = MainAction._getAlbumAtIndex(indexPath.row)!
        var _show:Manage_show?
        _show=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
        _show?._albumIndex=indexPath.row
        _show?._title = _album.objectForKey("title") as? String
        //_show?._setTitle(_album.objectForKey("title") as! String)
        _show?._range = _album.objectForKey("range") as! Int
        _show?._delegate=self
        self.navigationController?.pushViewController(_show!, animated: true)
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        return _resultArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
        let cell:AlbumListCell=_tableView!.dequeueReusableCellWithIdentifier("alum_cell", forIndexPath: indexPath) as! AlbumListCell
        //cell.separatorInset = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        
        //cell.textLabel?.text=_albumArray[indexPath.row] as? String
        
        if _resultArray.count<1{
            cell._changeToNew()
        }else{
            let _album:NSDictionary=_resultArray[indexPath.row] as! NSDictionary
            cell.setTitle((_album.objectForKey("title") as? String)!)
            cell.setTime("下午2:00")
            
            
            cell.setDescription(String(stringInterpolationSegment: MainAction._getImagesOfAlbumIndex(indexPath.row)!.count)+"张")
            //cell.detailTextLabel?.text="ss"
            
            let _pic:NSDictionary! = MainAction._getCoverFromAlbumAtIndex(indexPath.row)
            
            if _pic != nil{
                cell._setPic(_pic)
            }else{
                cell.setThumbImage("blank.png")
            }
            
        }
        //cell.imageView?.image=UIImage(named: _albumArray[indexPath.row] as! String)
        return cell
        
    }
    //----左滑
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if _resultArray.count<1{
            return []
        }
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除", handler: actionHander)
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "分享", handler: actionHander)
        // var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        
        //})
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑", handler: actionHander)
        //----设置颜色
        deleteAction.backgroundColor=UIColor(red: 255/255, green: 62/255, blue: 53/255, alpha: 1)
        shareAction.backgroundColor=UIColor(red: 255/255, green: 222/255, blue: 23/255, alpha: 1)
        editAction.backgroundColor=UIColor(red: 200/255, green: 199/255, blue: 205/255, alpha: 1)
        return [deleteAction,shareAction,editAction]
        
    }
    //---左滑动作
    func actionHander(action:UITableViewRowAction!,index:NSIndexPath!)->Void{
        // println(action, index.row)
        _tableView!.setEditing(false, animated: true)
        switch action.title as String!{
        case "删除":
            _currentIndex = index
            let _alert:UIAlertView = UIAlertView()
            _alert.delegate=self
            _alert.title="确定删除相册？"
            _alert.addButtonWithTitle("确定")
            _alert.addButtonWithTitle("取消")
            _alert.show()
            
        case "分享":
            openShare()
        case "编辑":
            editeAlbum(index.row)
            
        default:
            print(action.title)
        }
        
    }
    //-----提示按钮代理
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex==0{
            deleteCell(_currentIndex!)
        }
    }
    
    //---打开分享
    func openShare()->Void{
        
        
        if _shareAlert == nil{
            _shareAlert = ShareAlert()
            _shareAlert?._delegate = self
        }
        self.addChildViewController(_shareAlert!)
        self.view.addSubview(_shareAlert!.view)
        _shareAlert?._show()
        
    }
    //----弹出菜单代理
    func _myAlerterDidShow() {
        
    }
    func _myAlerterStartToClose() {
        
    }
    func _myAlerterClickAtMenuId(__id: Int) {
        switch __id{
        case 0:
            
            break
        case 1:
            
            break
        case 2:
            
            break
        default:
            break
        }
    }
    func _myAlerterDidClose() {
        if _alerter != nil{
            _alerter?.view.removeFromSuperview()
            _alerter?.removeFromParentViewController()
            _alerter = nil
        }
        
        _shareAlert?.view.removeFromSuperview()
        _shareAlert?.removeFromParentViewController()
        
        
    }
    //----删除相册
    func deleteCell(index:NSIndexPath)->Void{
        //_albumArray.removeAtIndex(index.row)
        //_tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Left)
        //_tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
        MainAction._deleteAlbumAtIndex(index.row)
        _search()
    
    }
    //----编辑相册
    func editeAlbum(index:Int) -> Void{
        
        var _controller:Manage_new?
        _controller=Manage_new()
        _controller?._albumIndex=index
        _controller?._delegate=self
        
        self.navigationController?.pushViewController(_controller!, animated: true)
    }
    //----弹出编辑\新建\图片到相册 代理
    func saved(dict: NSDictionary) {
        switch dict.objectForKey("Action_Type") as! String{
        case "new_album":
            MainAction._insertAlbum(dict)
        case "edite_album":
            MainAction._changeAlbumAtIndex(dict.objectForKey("albumIndex") as! Int, dict: dict)
        case "pics_to_album"://选择图片到指定相册
            MainAction._insertPicsToAlbumById( dict.objectForKey("images") as! NSArray, __albumIndex: dict.objectForKey("albumIndex") as! Int)
        case "pics_to_album_new"://选择图片到新建立相册
            var _controller:Manage_new?
            _controller=Manage_new()
            _controller?._delegate=self
            _controller?._imagesArray=NSMutableArray(array: dict.objectForKey("images") as! NSArray)
            self.navigationController?.pushViewController(_controller!, animated: true)
        default:
            print("")
        }
        _tableView!.reloadData()
    }
    func canceld() {
        _tableView!.reloadData()
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden=false
    }
    //---弹出浏览图片代理
    func didDeletedPics(dict: NSDictionary) {
        
        MainAction._changeAlbumAtIndex(dict.objectForKey("albumIndex") as! Int, dict: NSDictionary(object: dict.objectForKey("restImages")!, forKey: "images"))
        //----确定删除的图片：selectedImages
        
        _tableView!.reloadData()
    }
    func didAddPics(dict: NSDictionary) {
        MainAction._changeAlbumAtIndex(dict.objectForKey("albumIndex") as! Int, dict: NSDictionary(object: dict.objectForKey("allImages")!, forKey: "images"))
        
        //----添加的图片：addedImages
        
        _tableView!.reloadData()
    }
}