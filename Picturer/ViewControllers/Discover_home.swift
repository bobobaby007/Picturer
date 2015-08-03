//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Discover_home: UIViewController,UITabBarControllerDelegate {
    let _barH:CGFloat = 64
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    
    var _setuped:Bool=false
    
    var _referenceController:Discover_reference?
    var _searchController:Discover_search?
    var _tab_controller:MyTabBarController?
    
    var _tabBtnView:UIView?
    var _tab_reference:UIButton?
    var _tab_search:UIButton?

    
    
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: _barH))
        _btn_cancel?.setTitle("<", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _referenceController = Discover_reference()
        _searchController = Discover_search()
        
        
        _tab_controller = MyTabBarController()
        
        
        
        _tab_controller!.viewControllers = [_searchController!,_referenceController!]
        
        _tab_controller!.delegate = self
        _tab_controller?.tabBar.hidden = true
        
        
        self.view.addSubview(_tab_controller!.view)
        
        
        _tab_reference = UIButton()
        _tab_reference?.setTitle("发现", forState: UIControlState.Normal)
        _tab_reference?.frame=CGRect(x: 0, y: 0, width: 80, height: 34)
        _tab_reference?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _tab_search = UIButton()
        _tab_search?.setTitle("搜索", forState: UIControlState.Normal)
        _tab_search?.frame=CGRect(x: 80, y: 0, width: 80, height: 34)
        _tab_search?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _tabBtnView = UIView(frame: CGRect(x: 0.5*self.view.frame.width-80, y: 22, width: 160, height: 34))
        _tabBtnView?.layer.masksToBounds = true
        _tabBtnView?.layer.cornerRadius = 5
        _tabBtnView?.layer.borderWidth = 1
        _tabBtnView?.layer.borderColor = UIColor(red: 242/255, green: 206/255, blue: 53/255, alpha: 1).CGColor
        _tabBtnView?.clipsToBounds = true
        
        _tabBtnView?.addSubview(_tab_reference!)
        _tabBtnView?.addSubview(_tab_search!)
        
        
        
        _topBar?.addSubview(_tabBtnView!)
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        
        
        _switchTo(1)
        
        _setuped=true
    }
    
    func _switchTo(__num:Int){
        switch __num{
        case 1:
            _tab_reference?.backgroundColor=UIColor(red: 242/255, green: 206/255, blue: 53/255, alpha: 1)
            _tab_reference?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            _tab_search?.backgroundColor = UIColor.blackColor()
            _tab_search?.setTitleColor(UIColor(red: 242/255, green: 206/255, blue: 53/255, alpha: 1), forState: UIControlState.Normal)
            _tab_controller?.selectedIndex = 0
            return
        case 2:
            
            _tab_search?.backgroundColor=UIColor(red: 242/255, green: 206/255, blue: 53/255, alpha: 1)
            _tab_search?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            _tab_reference?.backgroundColor = UIColor.blackColor()
            _tab_reference?.setTitleColor(UIColor(red: 242/255, green: 206/255, blue: 53/255, alpha: 1), forState: UIControlState.Normal)
            _tab_controller?.selectedIndex = 1
            return
        default:
            return
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let _tran:TransitioningObject = TransitioningObject()
        if fromVC == _referenceController{
            _tran._isLeftToRight=true
        }else{
            _tran._isLeftToRight=false
        }
        
        return _tran
    }
    
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        
        case _tab_reference!:
            _switchTo(1)
            return
        case _tab_search!:
            _switchTo(2)
            return
        default:
            return
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
}



class MyTabBarController:UITabBarController {
   
}


class TransitioningObject: NSObject, UIViewControllerAnimatedTransitioning {
    
    var _isLeftToRight:Bool=false
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Get the "from" and "to" views
        let fromView : UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView : UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        transitionContext.containerView().addSubview(fromView)
        transitionContext.containerView().addSubview(toView)
        
        //The "to" view with start "off screen" and slide left pushing the "from" view "off screen"
        
        var fromNewFrame:CGRect
        
        if _isLeftToRight {
            toView.frame = CGRectMake(-1*toView.frame.width, 0, toView.frame.width, toView.frame.height)
            fromNewFrame = CGRectMake(fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
        }else{
            toView.frame = CGRectMake(toView.frame.width, 0, toView.frame.width, toView.frame.height)
            fromNewFrame = CGRectMake(-1 * fromView.frame.width, 0, fromView.frame.width, fromView.frame.height)
        }
        
        
        
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toView.frame = CGRectMake(0, 0, 320, 560)
            fromView.frame = fromNewFrame
            }) { (Bool) -> Void in
                // update internal view - must always be called
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.35
    }
}