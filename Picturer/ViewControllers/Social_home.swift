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

protocol Social_home_delegate:NSObjectProtocol{
    func _social_startToChange()
    func _social_changeCancel()
    func _social_changeFinished()
}


class Social_home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,Navi_Delegate{
    
    @IBOutlet weak var _collectionView:UICollectionView!
    @IBOutlet weak var _topView:UIView!
    
    
    
    var _offset:CGFloat=0
    var _isOuting:Bool = false
    var _isChanging:Bool = false

    var _collectionArray:NSArray=[["pic":"icon_1.png","title":"主页"],["pic":"icon_2.png","title":"朋友"],["pic":"icon_3.png","title":"妙人"],["pic":"icon_4.png","title":"发现"],["pic":"icon_5.png","title":"收藏"],["pic":"icon_6.png","title":"通讯录"],["pic":"icon_7.png","title":"设置"]]
    
    var _alertDicts:NSMutableArray?
    
    var _delegate:Social_home_delegate?
    
    var layout:LayoutForSocailHome?
    var bgColorV:UIView?
    var _whiteColorV:UIView?
    var _topBg:UIView?
    var _logoAnimation:LogoAnimation?
    var _lastPageTag:Int=0 //-----下一页返回时调用
    
    @IBAction func btnHander(btn:UIButton){
        switch btn{
            
        default:
            println("")
        }
        
        
    }
    
    //-----拖动方法
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if _isOuting{
            return
        }
        _isChanging = false
        _delegate?._social_changeCancel()
        
        //println("did end")
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if _isOuting{
            return
        }
        
        let _h:CGFloat=scrollView.contentOffset.y
        
        if _isChanging{
            
        }else{
            if _h < 0{
                _isChanging = true
                _delegate?._social_startToChange()
            }
        }
        
        bgColorV!.frame.origin = CGPoint(x: 0, y: 64 - _h)
        
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
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.bgColorV!.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            self._collectionView!.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            self._whiteColorV?.alpha = 0
            self._topView.alpha = 0
            self._topBg!.alpha = 0
            self._logoAnimation?.view.alpha = 0
            }) { (stop) -> Void in
                _delegate?._social_changeFinished()
        }
    }
    
    //

    func _getAlerts(){
        MainAction._getAlertsOfSocial({ (array) -> Void in
            self._alertDicts = NSMutableArray(array: array)
            self._collectionView.reloadData()
        })
    }
    
    //-----collection delegate
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collectionArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        _lastPageTag = indexPath.item
        switch indexPath.item{
        case 0://主页
            let _contr:MyHomepage=MyHomepage()
            _contr._userId =  MainAction._userId
            _contr._userName = MainAction._currentUser.objectForKey("userName") as? String
            _contr._naviDelegate = self
            self.navigationController?.pushViewController(_contr, animated: true)
        case 1://朋友
            
            var _contr:Friends_Home=Friends_Home()
            _contr._type="friends"
            _contr._naviDelegate = self
            self.navigationController?.pushViewController(_contr, animated: true)
                        
            return
        case 2://妙人
            var _contr:Friends_Home=Friends_Home()
            _contr._type="likes"
            _contr._naviDelegate = self
            self.navigationController?.pushViewController(_contr, animated: true)
            return
        case 3://发现
            let _contr:Discover_home=Discover_home()
            _contr._naviDelegate = self
            self.navigationController?.pushViewController(_contr, animated: true)
        case 4://收藏
            let _contr:Collect_home=Collect_home()
            _contr._naviDelegate = self
            self.navigationController?.pushViewController(_contr, animated: true)
            return
        case 5://通讯录
            return
        case 6://设置
            return
        default:
            println("22")
        }
    }
    
    //-------下个页面返回代理
    
    func _cancel() {
        
        switch _lastPageTag{
        case 0:
            var _dict:NSDictionary = NSDictionary(objects: [0,NSDictionary(objects: ["user_11.jpg","file"], forKeys: ["url","type"])], forKeys: ["num","pic"])
//            _alertDicts[0] =
            var _array:NSMutableArray = NSMutableArray(array: self._alertDicts!)
            _array[0]=_dict
            self._alertDicts = _array
            self._collectionView.reloadData()
            break
        case 1:
            var _dict:NSDictionary = NSDictionary(objects: [0,NSDictionary(objects: ["user_11.jpg","file"], forKeys: ["url","type"])], forKeys: ["num","pic"])
            //            _alertDicts[0] =
            var _array:NSMutableArray = NSMutableArray(array: self._alertDicts!)
            _array[1]=_dict
            self._alertDicts = _array
            self._collectionView.reloadData()
            break
        default:
            break
        }
        
         UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
         UIApplication.sharedApplication().statusBarHidden=false
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "SocailHomeCell"
        let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! SocailHomeCell
        cell._setTitle(_collectionArray[indexPath.item]["title"] as! String)
        
        
        
        if _alertDicts != nil{
            let _n:Int = (_alertDicts?.objectAtIndex(indexPath.item) as! NSDictionary).objectForKey("num") as! Int
            cell._setAlertNum(_n)
            if _n==0{
                cell._setImage( _collectionArray[indexPath.item]["pic"] as! String)
            }else{
                cell._setPic((_alertDicts?.objectAtIndex(indexPath.item) as! NSDictionary).objectForKey("pic") as! NSDictionary, __block: { (dict) -> Void in
                })
            }
            
        }else{
            cell._setImage( _collectionArray[indexPath.item]["pic"] as! String)
        }
        
        return cell
    }
    
    
    
    
    
    func switchToManage(){
        var _controller:Manage_home?
        _controller=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_home") as? Manage_home
        
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

    
    override func viewDidLoad() {
        //_scoller.contentSize=CGSize(width: _scoller.bounds.width, height: _scoller.bounds.height+100.0)
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false
        
        _getAlerts()
        
        
        if layout == nil{
            layout = LayoutForSocailHome()
            _collectionView.collectionViewLayout=layout!
            _collectionView.registerClass(SocailHomeCell.self, forCellWithReuseIdentifier: "SocailHomeCell")
            
            _collectionView.backgroundColor = UIColor.clearColor()
            
            
            bgColorV = UIView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height+500))
            bgColorV!.backgroundColor = UIColor.blackColor()
            
            _topBg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
            _topBg!.backgroundColor = UIColor.blackColor()
            
            _whiteColorV = UIView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height))
            _whiteColorV!.backgroundColor = UIColor.whiteColor()

            self.view.insertSubview(bgColorV!, atIndex: 0)
            self.view.insertSubview(_topBg!, atIndex: 0)
            self.view.insertSubview(_whiteColorV!, atIndex: 0)
            self.view.backgroundColor = UIColor.clearColor()
            
            _logoAnimation = LogoAnimation()
            _logoAnimation?._type = "black"
            self.addChildViewController(_logoAnimation!)
            self.view.insertSubview(_logoAnimation!.view, aboveSubview: bgColorV!)
            _logoAnimation?.view.frame = CGRect(x: 0, y: 0, width: 49, height: 49)
            _logoAnimation?.view.center = CGPoint(x: self.view.frame.width/2, y: 64+30)
            //self.view.addSubview(_logoAnimation!.view)
            
        }
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        _collectionView.frame.origin = CGPoint(x: 0, y: 64)
        self.bgColorV!.frame.origin = CGPoint(x: 0, y: 64)
        self.bgColorV?.alpha = 1
        self._topBg?.alpha=1
        self._whiteColorV?.alpha = 1
        self._topView.alpha = 1
        _isChanging = false
        _isOuting = false
        _logoAnimation?.view.alpha = 1
        _logoAnimation?._reset()
    }
    override func viewWillAppear(animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets =  false
       // UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
       // UIApplication.sharedApplication().statusBarHidden=false
    }
    
    
    
    
    
}
