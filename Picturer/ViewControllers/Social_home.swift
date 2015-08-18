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



class Social_home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var _collectionView:UICollectionView!
    
    var _offset:CGFloat=0

    var _collectionArray:NSArray=[["pic":"icon_1.png","title":"主页"],["pic":"icon_2.png","title":"朋友"],["pic":"icon_3.png","title":"妙人"],["pic":"icon_4.png","title":"发现"],["pic":"icon_5.png","title":"收藏"],["pic":"icon_6.png","title":"通讯录"],["pic":"icon_7.png","title":"设置"]]
    
    var _alertDicts:NSMutableArray?
    
    
    @IBAction func btnHander(btn:UIButton){
        switch btn{
            
        default:
            println("")
        }
        
        
    }
    
    //-----拖动方法
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        println("did end")
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if _offset < -80.0{
            _offset=0.0
            switchToManage()
        }
        _offset=0.0
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let _h:CGFloat=scrollView.contentOffset.y
        
        if _offset>_h{
            _offset=_h
        }
    }

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
        switch indexPath.item{
        case 0://主页
            let _contr:MyHomepage=MyHomepage()
            _contr._userId =  MainAction._userId
            _contr._userName = MainAction._currentUser.objectForKey("userName") as? String
            self.navigationController?.pushViewController(_contr, animated: true)
        case 1://朋友
            
            var _contr:Friends_Home=Friends_Home()
            _contr._type="friends"
            self.navigationController?.pushViewController(_contr, animated: true)
                        
            return
        case 2://妙人
            var _contr:Friends_Home=Friends_Home()
            _contr._type="likes"
            self.navigationController?.pushViewController(_contr, animated: true)
            return
        case 3://发现
            let _contr:Discover_home=Discover_home()
            self.navigationController?.pushViewController(_contr, animated: true)
        case 4://收藏
            let _contr:Collect_home=Collect_home()
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
        
        let layout = LayoutForSocailHome()
        _collectionView.collectionViewLayout=layout
        _collectionView.registerClass(SocailHomeCell.self, forCellWithReuseIdentifier: "SocailHomeCell")
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
    }
    
    
    
    
    
}
