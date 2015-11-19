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

protocol Manage_home_delegate:NSObjectProtocol{
    func _manage_startToChange()
    func _manage_changeCancel()
    func _manage_changeFinished()
}

class Manage_home: UIViewController,UITableViewDelegate,UITableViewDataSource,Manage_newDelegate,Manage_show_delegate,ImagePickerDeletegate,Manage_PicsToAlbumDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MyAlerter_delegate,ShareAlert_delegate{
    var _alerter:MyAlerter?
    var _shareAlert:ShareAlert?
    var _cameraPicker:UIImagePickerController!
    //var _albumArray:[AnyObject]=["1.png","2.png","3.png","4.png","5.png","6.png","7.png"]
    @IBOutlet weak var _tableView:UITableView!
    @IBOutlet weak var _btn_new:UIButton!
    @IBOutlet weak var _btn_camera:UIButton!
    @IBOutlet weak var _topView:UIView!
    @IBOutlet weak var _bottomView:UIView!
    @IBOutlet weak var _addIcon:UIImageView!
    
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
    
    @IBAction func btnHander(btn:UIButton){
        switch btn{
        case _btn_new:
            
            if _shareAlert != nil && _shareAlert!._isOpened{
                _shareAlert!._close()
                return
            }
            
            
            if _alerter != nil && _alerter!._isOpened{
                _alerter!._close()
            }else{
                openNewActions()
            }
            
            
        case _btn_camera:
            _openCamera()
            return
        default:
            print("", terminator: "")
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if _isOuting{
            return
        }
        _isChanging = false
        _delegate?._manage_changeCancel()
        //UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        //println("did end")
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if _isOuting{
            return
        }
        
        
        if _isChanging{
            
        }else{
            _isChanging = true
            _delegate?._manage_startToChange()
        }
        
        let _h:CGFloat=scrollView.contentOffset.y
        
        var _whiteTo:CGFloat = 64-_h
        if _whiteTo<64{
            _whiteTo = 64
        }
        _whiteBg?.frame.origin.y = _whiteTo
        
        
        
        
        var _y:CGFloat = 64-_h/2
        
        
        var _n:Int = -Int(floor((_h+10)/4))
        if _n<0{
            _n=0
        }
        _logoAnimation?._changeTo(_n)
        
        if _n <= 6{
            _y = _y+3*7
        }else if _n <= 12{
            _y = _y + CGFloat(12-_n)*7/2
        }else{
            
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self._logoAnimation?.view.center = CGPoint(x: self.view.frame.width/2, y: _y)
            self._logoAnimation?.view.alpha = 1-CGFloat(25-_n)*0.04
        })
        
        
        
        
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let _h:CGFloat=scrollView.contentOffset.y
        if _h < -120{
            out()
        }
    }
    func out(){
        //_tableView.userInteractionEnabled = false
        _isOuting = true
       // _tableView.bounces = false
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._tableView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            self._blurV?.alpha = 0
            self._topView.alpha = 0
            self._bottomView.alpha = 0
            self._logoAnimation?.view.alpha = 0
            
            self._whiteBg!.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            
        }) { (stop) -> Void in
            self._delegate?._manage_changeFinished()
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
        //return _tableView.bounds.size.height/5
        
        return 91
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if MainAction._albumList.count<1{
            newAlbum()
            return
        }
        
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
        self.view.insertSubview(_shareAlert!.view, belowSubview: _bottomView)
        _shareAlert?._show()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._addIcon.transform = CGAffineTransformMakeRotation(3.14*1.25)
        })
        
//        let rateMenu = UIAlertController(title: "分享", message: "分享这个相册", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        let appRateAction = UIAlertAction(title: "微博", style: UIAlertActionStyle.Default, handler: nil)
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//        rateMenu.addAction(appRateAction)
//        rateMenu.addAction(cancelAction)
//        self.presentViewController(rateMenu, animated: true, completion: nil)
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
    //---新建
    func openNewActions()->Void{
        
        if _alerter == nil{
            _alerter = MyAlerter()
            _alerter?._delegate = self
        }
        self.addChildViewController(_alerter!)
        self.view.insertSubview(_alerter!.view, belowSubview: _bottomView)
        _alerter?._setMenus(["创建图册","添加图片","抓取网页"])
        _alerter?._canelButton?.hidden=true
        _alerter?._show()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._addIcon.transform = CGAffineTransformMakeRotation(3.14*1.25)
        })
        
        /*
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
*/
    }
    
    
    //----弹出菜单代理
    func _myAlerterDidShow() {
        
    }
    func _myAlerterStartToClose() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._addIcon.transform = CGAffineTransformMakeRotation(0)
        })
    }
    func _myAlerterClickAtMenuId(__id: Int) {
        switch __id{
        case 0:
            newAlbum()
            break
        case 1:
            newFromLocal()
            break
        case 2:
            newFromWeb()
            break
        default:
            break
        }
    }
    func _myAlerterDidClose() {
        _alerter?.view.removeFromSuperview()
        _alerter?.removeFromParentViewController()
        
        _shareAlert?.view.removeFromSuperview()
        _shareAlert?.removeFromParentViewController()
        
        _alerter = nil
    }
    
    
    
    //---创建新相册
    func newAlbum() -> Void{
        var _controller:Manage_new?
        _controller=Manage_new()
        _controller?._delegate=self
        // println(_show)
        //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
        self.navigationController?.pushViewController(_controller!, animated: true)
    }
    //---添加新照片
    func newFromLocal() -> Void{
        var _controller:Manage_imagePicker?
        _controller=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_imagePicker") as? Manage_imagePicker
        _controller?._delegate=self
        //self.view.window?.rootViewController?.presentViewController(_controller!, animated: true, completion: nil)
       // self.presentViewController(_controller!, animated: true, completion: nil)
        self.navigationController?.pushViewController(_controller!, animated: true)
        
    }
    //---创建新相册
    func newFromWeb() -> Void{
        
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
    
   
    
    //-----弹出新建相册选择图片代理
    
    func imagePickerDidSelected(images: NSArray) {
        //println(images)
        var _controller:Manage_PicsToAlbum?
        _controller=Manage_PicsToAlbum()
        _controller?._delegate=self
        _controller?._imagesArray=NSMutableArray(array: images)
        // println(_show)
        //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
       // self.navigationController?.popViewControllerAnimated(false)
        self.navigationController?.pushViewController(_controller!, animated: true)
    }
    
    
    //---------相机
    
    func _openCamera(){
        _cameraPicker =  UIImagePickerController()
        _cameraPicker.delegate = self
        _cameraPicker.sourceType = .Camera
        //self.view.window!.rootViewController!.presentViewController(_cameraPicker, animated: true, completion: nil)
        
        presentViewController(_cameraPicker!, animated: true, completion: nil)
        
       // println("9999")
    }
    //----相机代理方法
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        _cameraPicker.dismissViewControllerAnimated(true, completion: nil)
        
        
        //_loadImagesAt(0)
        
        //var _alassetsl:ALAssetsLibrary = ALAssetsLibrary()
        //println(info)
        
        //let image:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        
        
        
        //_alassetsl.writeImageToSavedPhotosAlbum(image.CGImage, orientation: image.imageOrientation, completionBlock: cameraSaveOk)
        
        
        //_alassetsl.writeImageToSavedPhotosAlbum(image.CGImage,orientation: image.imageOrientation,completionBlock:{ (path:NSURL!, error:NSError!) -> Void in    println("\(path)")  })
        
        // _alassetsl.writeImageToSavedPhotosAlbum(image.CGImage, orientation: image.imageOrientation, completionBlock: Selector("cameraSaveOk:"))
        
        
        
       UIImageWriteToSavedPhotosAlbum((info[UIImagePickerControllerOriginalImage] as? UIImage)!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        //_cameraPicker.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func cameraSaveOk(URL:NSURL, Error:NSError)->Void{
        //let _url:NSString=URL.absoluteString
        //let _dict:NSDictionary = NSDictionary(objects: [_url,"alasset"], forKeys: ["url","type"])
        //asset.originalAsset = result
        //self._images!.insertObject(_dict, atIndex: 0)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            
            let library:ALAssetsLibrary = ALAssetsLibrary()
            library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: {(group: ALAssetsGroup! , outStop: UnsafeMutablePointer<ObjCBool>) in
                if group != nil {
                    group.enumerateAssetsUsingBlock {[unowned self](result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
                        if result != nil {
                                //let asset = DKAsset()
                                let _nsurl:NSURL = (result.valueForProperty(ALAssetPropertyAssetURL) as? NSURL)!
                                let _url:NSString=_nsurl.absoluteString
                                let _dict:NSDictionary = NSDictionary(objects: [_url,"alasset"], forKeys: ["url","type"])
                                self._cameraImage = _dict
                            // println(self._cameraImage)
                        } else {
                            self.imagePickerDidSelected([self._cameraImage!])
                        }}
                }else {
                    
                }
                
                }, failureBlock: {(error: NSError!) in
                    //---没有相册
            })
            
            
        } else {
            let ac = UIAlertController(title: "保存失败", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
        
        
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
        setup()
       // _tableView.separatorColor=UIColor.clearColor()
    }
    
    func setup(){
        if _setuped{
            return
        }
        if _blurV ==  nil{
            //let blurEffect:UIBlurEffect=UIBlurEffect(style: UIBlurEffectStyle.Dark)
            _blurV = UIImageView(image: UIImage(named: "blurBg.jpg"))
            _blurV?.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
            self.view.insertSubview(_blurV!, belowSubview: _tableView)
            _whiteBg = UIView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height))
            _whiteBg?.backgroundColor = UIColor.whiteColor()
            //_tableView.tableFooterView = UIView()
            _tableView.tableFooterView=UIView(frame: CGRect(x: 0, y: 0, width: _tableView.frame.width, height:10))
            let _line:UIView = UIView(frame: CGRect(x: 10, y: 0, width: 500, height: 0.5))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            _tableView.tableFooterView?.addSubview(_line)
            _tableView.backgroundColor = UIColor.clearColor()
            _tableView.tableFooterView?.backgroundColor = UIColor.whiteColor()
            self.view.backgroundColor = UIColor.clearColor()
            self.automaticallyAdjustsScrollViewInsets=false
            
            
            _logoAnimation = LogoAnimation()
            self.addChildViewController(_logoAnimation!)
            _logoAnimation?.view.frame = CGRect(x: 0, y: 0, width: 49, height: 49)
            _logoAnimation?.view.center = CGPoint(x: self.view.frame.width/2, y: 64+30)
            //self.view.addSubview(_logoAnimation!.view)
            
            self.view.insertSubview(_logoAnimation!.view, aboveSubview: _blurV!)
            self.view.insertSubview(_whiteBg!, aboveSubview: _blurV!)
        }
        
        _setuped = true
    }
    override func viewDidAppear(animated: Bool) {
        //UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        //UIApplication.sharedApplication().statusBarHidden=false
        _blurV!.frame = CGRect(x: 0, y: 64, width: 500, height: 600)
        _tableView.frame.origin = CGPoint(x: 0, y: 64)
        self._blurV?.alpha = 1
        self._topView.alpha = 1
        self._bottomView.alpha = 1
        _isChanging = false
        _isOuting = false
        _logoAnimation?.view.alpha = 1
        _logoAnimation?._reset()
        _whiteBg!.frame.origin = CGPoint(x: 0, y: 64)
    }
    override func viewWillAppear(animated: Bool) {
    
    }
    
    
    
}
