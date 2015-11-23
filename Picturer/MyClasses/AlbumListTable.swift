//
//  Manage_home.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/16.
//  Copyright (c) 2015年 4view. All rights reserved.
//

//------管理——首页

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation

protocol AlbumListTable_delegate:NSObjectProtocol{
    func _manage_startToChange()
    func _manage_changeCancel()
    func _manage_changeFinished()
}

class AlbumListTable: UIViewController,UITableViewDelegate,UITableViewDataSource,Manage_newDelegate,Manage_show_delegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ShareAlert_delegate{
    var _alerter:MyAlerter?
    var _shareAlert:ShareAlert?
    var _cameraPicker:UIImagePickerController!
    var _searchPage:SearchPage?
    //var _albumArray:[AnyObject]=["1.png","2.png","3.png","4.png","5.png","6.png","7.png"]
    var _tableView:UITableView!
    
    
    var _offset:CGFloat=0
    var _currentIndex:NSIndexPath?
    
    var _cameraImage:NSDictionary?
    
    weak var _delegate:Manage_home_delegate!
    
    var _blurV:UIImageView?
    var _whiteBg:UIView?
    var _isOuting:Bool = false
    var _isChanging:Bool = false
    var _logoAnimation:LogoAnimation?
    
    var _setuped:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        _tableView.tableFooterView=UIView(frame: CGRect(x: 0, y: 0, width: _tableView.frame.width, height:10))
        _tableView.backgroundColor = UIColor.clearColor()
        _tableView.tableFooterView?.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.clearColor()
        self.automaticallyAdjustsScrollViewInsets=false
        _setuped = true
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
        if MainAction._albumList.count<1{
            return 1
        }
        //return MainAction._albumList.count
        return MainAction._albumList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
        let cell:AlbumListCell=_tableView.dequeueReusableCellWithIdentifier("alum_cell", forIndexPath: indexPath) as! AlbumListCell
        //cell.separatorInset = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        
        //cell.textLabel?.text=_albumArray[indexPath.row] as? String
        
        if MainAction._albumList.count<1{
            cell._changeToNew()
        }else{
            let _album:NSDictionary=MainAction._albumList[indexPath.row] as! NSDictionary
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
        if MainAction._albumList.count<1{
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
        _tableView.setEditing(false, animated: true)
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
        
        _tableView.reloadData()
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
        _tableView.reloadData()
    }
    func canceld() {
        _tableView.reloadData()
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden=false
    }
    //---弹出浏览图片代理
    func didDeletedPics(dict: NSDictionary) {
        
        MainAction._changeAlbumAtIndex(dict.objectForKey("albumIndex") as! Int, dict: NSDictionary(object: dict.objectForKey("restImages")!, forKey: "images"))
        //----确定删除的图片：selectedImages
        
        _tableView.reloadData()
    }
    func didAddPics(dict: NSDictionary) {
        MainAction._changeAlbumAtIndex(dict.objectForKey("albumIndex") as! Int, dict: NSDictionary(object: dict.objectForKey("allImages")!, forKey: "images"))
        
        //----添加的图片：addedImages
        
        _tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    
}
