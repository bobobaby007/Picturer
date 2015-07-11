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



class Manage_home: UIViewController,UITableViewDelegate,UITableViewDataSource,Manage_newDelegate{
   
    //var _albumArray:[AnyObject]=["1.png","2.png","3.png","4.png","5.png","6.png","7.png"]
    
    @IBOutlet weak var _tableView:UITableView!
    @IBOutlet weak var _btn_new:UIButton!
    
    var _offset:CGFloat=0
    
    @IBAction func btnHander(btn:UIButton){
        switch btn{
        case _btn_new:
            openNewActions()            
        default:
            println("")
        }
    }
    func switchToSocial(){
        var _controller:Social_home?
        _controller=self.storyboard?.instantiateViewControllerWithIdentifier("Social_home") as? Social_home
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        
        // Set the starting value
        animation.fromValue = self.navigationController?.view.layer.cornerRadius
        
        // Set the completion value
        animation.toValue = 0
        
        // How may times should the animation repeat?
        animation.repeatCount = 1000
        
        // Finally, add the animation to the layer
        self.navigationController?.view.layer.addAnimation(animation, forKey: "cornerRadius")
        
        self.navigationController?.pushViewController(_controller!, animated: false)
        
        
        
     
    }
    
    
    
    //-----拖动方法
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        println("did end")
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if _offset < -80.0{
          _offset=0.0
          switchToSocial()
        }
        _offset=0.0
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let _h:CGFloat=scrollView.contentOffset.y
        if _offset>_h{
            _offset=_h
        }
    }
    //---------tableview delegate
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return _tableView.bounds.size.height/5
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if MainAction._albumList.count<1{
            newAlbum(nil)
            return
        }
        var _show:Manage_show?
        _show=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
    
        _show?._albumIndex=indexPath.row
    //_show?._setPicArray(["1.png","2.png","3.png","4.png","5.png","6.png","7.png","1.png","2.png","3.png","4.png","5.png","6.png","7.png","1.png","2.png","3.png","4.png","5.png","6.png","7.png","6.png","7.png"])
        
       // println(_show)
     //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
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
        
        
        
        //cell.textLabel?.text=_albumArray[indexPath.row] as? String
        
        if MainAction._albumList.count<1{
            cell._changeToNew()
        }else{
            let _album:NSDictionary=MainAction._albumList[indexPath.row] as! NSDictionary
            cell.setTitle((_album.objectForKey("title") as? String)!)
            cell.setTime("下午2:00")
            //cell.setDescription((_albumArray[indexPath.row] as? String)!+"张")
            //cell.detailTextLabel?.text="ss"
            
            if _album.objectForKey("cover") != nil{
                cell._setPic(_album.objectForKey("cover") as! NSDictionary)
                //cell.setThumbImage(_album.objectForKey("cover") as! String)
            }else{
                cell.setThumbImage("1.png")   
            }
            
        }
        
        
       
        //cell.imageView?.image=UIImage(named: _albumArray[indexPath.row] as! String)
        
        
        return cell
        
    }
    //----左滑
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        if MainAction._albumList.count<1{
            return []
        }
        
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除", handler: actionHander)
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "分享", handler: actionHander)
       // var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
        //})
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑", handler: actionHander)
        //----设置颜色
        deleteAction.backgroundColor=UIColor(red: 255/255, green: 62/255, blue: 53/255, alpha: 1)
        shareAction.backgroundColor=UIColor(red: 255/255, green: 222/255, blue: 23/255, alpha: 1)
        editAction.backgroundColor=UIColor(red: 200/255, green: 199/255, blue: 205/255, alpha: 1)
        return [deleteAction,shareAction,editAction]
        
    }
    //---左滑动作
    func actionHander(action:UITableViewRowAction!,index:NSIndexPath!)->Void{
       // println(action, index.row)
        switch action.title{
            case "删除":
            println("删除")
            deleteCell(index)
            case "分享":
            openShare()
            case "编辑":
            editeAlbum(index.row)
            
            default:
            println(action.title)
        }
    }
    //---打开分享
    func openShare()->Void{
        let rateMenu = UIAlertController(title: "分享", message: "分享这个相册", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let appRateAction = UIAlertAction(title: "微博", style: UIAlertActionStyle.Default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        rateMenu.addAction(appRateAction)
        rateMenu.addAction(cancelAction)
        self.presentViewController(rateMenu, animated: true, completion: nil)
    }
    //----删除相册
    func deleteCell(index:NSIndexPath)->Void{
        //_albumArray.removeAtIndex(index.row)
        //_tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Left)
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
    //---新建
    func openNewActions()->Void{
        //let rateMenu = UIAlertController(title: "新建相册", message: "选择一种新建方式", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let menu=UIAlertController()
        let action1 = UIAlertAction(title: "创建新相册", style: UIAlertActionStyle.Default, handler: newAlbum)
        let action2 = UIAlertAction(title: "添加新照片", style: UIAlertActionStyle.Default, handler: newFromLocal)
        let action3 = UIAlertAction(title: "从网页提取", style: UIAlertActionStyle.Default, handler: newFromWeb)
        let action4 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        menu.addAction(action1)
        menu.addAction(action2)
        menu.addAction(action3)
        menu.addAction(action4)        
        self.view.window!.rootViewController!.presentViewController(menu, animated: true, completion: nil)
        //self.presentViewController(menu, animated: true, completion: nil)
    }
    //---创建新相册
    func newAlbum(action:UIAlertAction!) -> Void{
        var _controller:Manage_new?
        _controller=Manage_new()
        _controller?._delegate=self
        // println(_show)
        //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
        self.navigationController?.pushViewController(_controller!, animated: true)
    }
    //---添加新照片
    func newFromLocal(action:UIAlertAction!) -> Void{
        var _controller:Manage_imagePicker?
        _controller=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_imagePicker") as? Manage_imagePicker
        
        //self.view.window?.rootViewController?.presentViewController(_controller!, animated: true, completion: nil)
       // self.presentViewController(_controller!, animated: true, completion: nil)
        self.navigationController?.pushViewController(_controller!, animated: true)
        
    }
    
    //----弹出代理
    func saved(dict: NSDictionary) {
        switch dict.objectForKey("Action_Type") as! String{
            case "new_album":
            MainAction._insertAlbum(dict)
            case "edite_album":
            MainAction._changeAlbumAtIndex(dict.objectForKey("albumIndex") as! Int, dict: dict)
        default:
            println("")
        }
        _tableView.reloadData()
    }
    func canceld() {
        _tableView.reloadData()
    }
    //---创建新相册
    func newFromWeb(action:UIAlertAction!) -> Void{
        
    }
    
    
    
    
    override func viewDidLoad() {
        
//        var _album:AlbumObj=AlbumObj()
//        var _images:NSMutableArray = [["sss":"44"]]
//        
//        for var i=0;i<3; ++i{
//            var _pic:PicObj=PicObj()
//            _pic.thumbImage = "33333" + String(i)
//            _album.images.addObject(_pic)
//        }
//        println(_album._toDict())

       // println(MainAction._albumList)
        super.viewDidLoad()
       // _tableView.separatorColor=UIColor.clearColor()
        _tableView.tableFooterView=UIView()
        
        self.automaticallyAdjustsScrollViewInsets=false
        
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
    
    
    
    
}
