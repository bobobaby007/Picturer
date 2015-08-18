//
//  ViewController.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/14.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit

class ViewController: UIViewController,Manage_home_delegate,Social_home_delegate{

   
   weak var manage_home:Manage_home?
   weak var socail_home:Social_home?
    var _navgationController:UINavigationController?
    var _setuped:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showManageHome()
        //showSocialHome()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func setup()->Void{
        if _setuped{
            return
        }
        if _navgationController == nil{
            _navgationController = UINavigationController()
        }
        self.view.addSubview(_navgationController!.view)
        _navgationController!.view.backgroundColor = UIColor.clearColor()
        _navgationController!.navigationBarHidden=true
        
        _setuped=true
        
       // _navgationController.addChildViewController(manage_home!)
    }
    //----显示编辑首页
    func showManageHome(){
        if (manage_home != nil){
            //println("有")
        }else{
            //  println("没")
            manage_home=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_home") as? Manage_home
            manage_home?._delegate = self
        }
        
        
       _navgationController!.pushViewController(manage_home!, animated: false)
       // self.navigationController?.presentViewController(manage_home!, animated: true, completion: { () -> Void in
         //   println("22")
        //})
        //self.view.addSubview(manage_home!.view)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        //UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        }
    func showSocialHome(){
        
        
        if (socail_home != nil){
            //println("有")
        }else{
            //  println("没")
            socail_home=self.storyboard?.instantiateViewControllerWithIdentifier("Social_home") as? Social_home
            socail_home?._delegate = self
        }
        
        
        _navgationController!.pushViewController(socail_home!, animated: false)
        
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        
        //UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.Default
        // self.navigationController?.presentViewController(manage_home!, animated: true, completion: { () -> Void in
        //   println("22")
        //})
        
        //self.view.addSubview(manage_home!.view)
        
    }
    
    
    //-----代理
    
    func _manage_startToChange() {
        if (socail_home != nil){
            //println("有")
        }else{
            //  println("没")
            socail_home=self.storyboard?.instantiateViewControllerWithIdentifier("Social_home") as? Social_home
            socail_home?._delegate = self
        }
        
        self.addChildViewController(socail_home!)
        
        //println(socail_home)
        
        //_navgationController.view.insertSubview(socail_home!.view, belowSubview: manage_home!.view)
        self.view.insertSubview(socail_home!.view, belowSubview: _navgationController!.view)
        
    }
    func _manage_changeCancel() {
        if (socail_home != nil){
            socail_home?.removeFromParentViewController()
            socail_home?.view.removeFromSuperview()
        }
    }
    func _manage_changeFinished() {
        showSocialHome()
    }
    func _social_startToChange() {
        if (manage_home != nil){
            //println("有")
        }else{
            //  println("没")
            manage_home=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_home") as? Manage_home
            manage_home?._delegate = self
        }
        
        self.addChildViewController(manage_home!)
        
        //_navgationController.view.insertSubview(socail_home!.view, belowSubview: manage_home!.view)
        self.view.insertSubview(manage_home!.view, belowSubview: _navgationController!.view)
    }
    func _social_changeCancel() {
        if (manage_home != nil){
            manage_home?.removeFromParentViewController()
            manage_home?.view.removeFromSuperview()
        }
    }
    func _social_changeFinished() {
        showManageHome()
    }

}

