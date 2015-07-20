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

    
    //-----collection delegate
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collectionArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.item{
        case 0:
            let _contr:MyHomepage=MyHomepage()
            self.navigationController?.pushViewController(_contr, animated: true)
            
        default:
            println("22")
        }
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "SocailHomeCell"
        let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! SocailHomeCell
        
        cell._setImage( _collectionArray[indexPath.item]["pic"] as! String)
        cell._setTitle(_collectionArray[indexPath.item]["title"] as! String)
        
        if indexPath.item%2==1{
            
            cell._setAlertNum(8)
           // cell._setAlertNum(2120)
        }else{
            cell._setAlertNum(-1)
        }
        
        if indexPath.item%3==1{
            cell._setAlertNum(0)
        }else{
            
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
        
        
        
        let layout = LayoutForSocailHome()
        _collectionView.collectionViewLayout=layout
        _collectionView.registerClass(SocailHomeCell.self, forCellWithReuseIdentifier: "SocailHomeCell")
        
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
    }
    
    
    
    
    
}
